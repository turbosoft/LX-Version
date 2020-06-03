package kr.co.turbosoft.api;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import kr.co.turbosoft.dao.DataDao;
import kr.co.turbosoft.dao.PgmDao;
import kr.co.turbosoft.util.DataTableUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.codehaus.jackson.JsonParser;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

@Controller
public class PgmAPI
{
	static Logger log = Logger.getLogger(PgmAPI.class.getName());

	static PgmDao pgmDao = null;
	
	static DataDao dataDao = null;
	
	@Autowired
	DataSource dataSource;

	public void setPgmDao(PgmDao pgmDao){
		this.pgmDao = pgmDao;
	}
	
	public void setDataDao(DataDao dataDao){
		this.dataDao = dataDao;
	}
	
	private String b_serverUrl = "";
	private String b_serverPort = "";
	private String b_serverId = "";
	private String b_serverPass = "";
	private String b_serverPath = "";
	private boolean isServerUrl = false;
	
	@RequestMapping(value = "/pgm/saveLayer/{tableName}/{tableType}", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String saveLayerService(@RequestParam("callback") String callback
			, @PathVariable("tableName") String tableName
			, @PathVariable("tableType") String tableType
			, Model model, HttpServletRequest request, HttpServletResponse response) {
		response .setHeader("Access-Control-Allow-Methods" , "POST, GET, OPTIONS, DELETE" );
		response.setHeader( "Access-Control-Max-Age" , "3600" );
		response.setHeader( "Access-Control-Allow-Headers" , "x-requested-with" );
		response.setHeader( "Access-Control-Allow-Origin" , "*" );

		JSONObject resultJSON = new JSONObject();
		
		try {
			if(tableName == null || tableName == "" || tableName == "null"){
				resultJSON.put("Code", 600);
				resultJSON.put("Message", Message.code600);
			}
				
			DefaultTransactionDefinition def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
			JdbcTemplate template = new JdbcTemplate(dataSource);
			DataSourceTransactionManager txManager = new DataSourceTransactionManager(dataSource);
			TransactionStatus sts = txManager.getTransaction(def);
			
			try{
				boolean chkVideo = false;
				boolean chkPhoto = false;
				boolean chkSensor = false;
				boolean chkTraj = false;
				
				List<String> sensorList = new ArrayList<String>();
				
				tableName = dataReplaceFun(tableName);
				
				if(tableType != null && !"".equals(tableType) && !"null".equals(tableType)){
					ObjectMapper m = new ObjectMapper();
					try{
						List<HashMap<String, String>> saveAttrList = m.readValue(tableType, new TypeReference<List<HashMap<String, String>>>() { });
						
						String createSql = "";
						String createColumns = "idxseq BIGSERIAL PRIMARY KEY,";
						String attributeCheckVideo = "";
						String attributeCheckPhoto = "";
						String attributeCheckTraj = "";
						
						for (HashMap<String, String> saveAttrMap : saveAttrList) {
							String attribute = saveAttrMap.get("attribute");
							String type = saveAttrMap.get("type");
							
							if ("mvideo".equalsIgnoreCase(type)) {
								chkVideo = true;
								attributeCheckVideo = attribute;
							} else if ("stphoto".equalsIgnoreCase(type)) {
								chkPhoto = true;
								attributeCheckPhoto = attribute;
							} else if ("mdouble".equalsIgnoreCase(type)) {
								chkSensor = true;
								sensorList.add(attribute);
							} else if ("mpoint".equalsIgnoreCase(type)) {
								chkTraj = true;
								attributeCheckTraj = attribute;
							} else {
								createColumns += attribute + " " + type + ",";
							}
						}
						
						createColumns = createColumns.substring(0, createColumns.length() - 1);
						createSql = "CREATE TABLE " + tableName + "(" + createColumns + ");";
						
						template.execute(createSql);
						
						if (chkVideo) {
							String addColumnSql = "select addmgeometrycolumn ('public', '" + tableName + "', '"+attributeCheckVideo+"', 4326, 'mvideo', 2, 3000);";
							template.execute(addColumnSql);
						}
						
						if (chkPhoto) {
							String addColumnSql = "select addmgeometrycolumn ('public', '" + tableName + "', '"+attributeCheckPhoto+"', 4326, 'stphoto', 2, 1);";
							template.execute(addColumnSql);
						}
						
						if (chkSensor) {
							for (String sensor : sensorList) {
								String addColumnSql = "select addmgeometrycolumn ('public', '" + tableName + "', '" + sensor + "', 4326, 'mdouble', 2, 3000);";
								template.execute(addColumnSql);
							}
						}
						
						if (chkTraj) {
							String addColumnSql = "select addmgeometrycolumn ('public', '" + tableName + "', '"+attributeCheckTraj+"', 4326, 'mpoint', 2, 50);";
							template.execute(addColumnSql);
						}
						
						resultJSON.put("Code", 100);
						resultJSON.put("Message", Message.code100);
					}catch(Exception e){
						resultJSON.put("Code", 600);
						resultJSON.put("Message", Message.code600);
					}
				}
				
				txManager.commit(sts);
			}catch(Exception e){
				e.printStackTrace();
				txManager.rollback(sts);
				resultJSON.put("Code", 800);
				resultJSON.put("Message", Message.code800);
			}
		} catch (Exception e) {
			e.printStackTrace();
			resultJSON.put("Code", 800);
			resultJSON.put("Message", Message.code800);
		}
		
		return callback + "(" + resultJSON.toString() + ")";
	}
	
	@RequestMapping(value = "/pgm/getLayer/{projectId}", method = RequestMethod.GET, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String baseService(@RequestParam("callback") String callback
			, @PathVariable("projectId") String projectId
			, Model model, HttpServletRequest request) {
		JSONObject resultJSON = new JSONObject();
		List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();
		List<Map<String, String>> resultUserList = new ArrayList<Map<String, String>>();
		
		try {
			//get Base
			Map<String, String> param = new HashMap<String, String>();
			param.put("projectId", projectId);
			String tableName = pgmDao.getLayerTableName(param);
			param.put("tableName", tableName);
			resultList = pgmDao.selectLayerTableColumns(param); // attr, type
			resultUserList = pgmDao.selectLayerUserColumns(param); // mgeometry columns
			if(resultList != null && resultList.size()>0) {
				resultJSON.put("Code", 100);
				resultJSON.put("Message", Message.code100);
				resultJSON.put("Data", resultList);
				resultJSON.put("userData", resultUserList);
			}else {
				resultJSON.put("Code", 200);
				resultJSON.put("Message", Message.code200);
			}
		} catch (Exception e) {
			e.printStackTrace();
			resultJSON.put("Code", 800);
			resultJSON.put("Message", Message.code800);
		}
		
		return callback + "(" + resultJSON.toString() + ")";
	}
	@RequestMapping(value = "/pgm/urlOption/{url}/{type}", method = RequestMethod.GET, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String urlOptionService(@RequestParam("callback") String callback
			, @PathVariable("url") String myurl
			, @PathVariable("type") String type
			, Model model, HttpServletRequest request) {
		
		URL url         = null;
		StringBuffer sbHtml     = new StringBuffer();
		JSONObject jsb     = new JSONObject();
		InputStream is       = null;
	  	BufferedReader br      = null;
		String data        = null;
		HttpURLConnection hurlc   = null;
		URLConnection urlc     = null;
		HttpURLConnection huc = null;

		try {
			//get Base
			
			url = new URL("http://djr.urbanai.net/task?url=http://106.246.9.37:8127/GeoCMS/upload/GeoPhoto/"+myurl+"."+type+"&model_name=mscoco_maskrcnn&file_type=image");
			
			huc = (HttpURLConnection)url.openConnection();

			// request header set
			huc.setRequestProperty("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
			huc.setRequestProperty("Accept-Charset", "windows-949,utf-8;q=0.7,*;q=0.3");
			huc.setRequestProperty("Accept-Encoding", "gzip,deflate,sdch");
			huc.setRequestProperty("Accept-Language", "ko-KR,ko;q=0.8,en-US;q=0.6,en;q=0.4");
			huc.setRequestProperty("Connection", "keep-alive");
		
			huc.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.75 Safari/535.7");
			
			br = new BufferedReader(new InputStreamReader(huc.getInputStream(), "UTF-8"));
			
			while((data = br.readLine()) != null ){
				
			}


		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return data;
	}
	@RequestMapping(value = "/pgm/getTableName/{projectId}", method = RequestMethod.GET, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String getTableName(@RequestParam("callback") String callback
			, @PathVariable("projectId") String projectId
			, Model model, HttpServletRequest request) {
		JSONObject resultJSON = new JSONObject();
		List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();
		
		try {
			//get Base
			Map<String, String> param = new HashMap<String, String>();
			param.put("projectId", projectId);
			String tableName = pgmDao.getLayerTableName(param);
			param.put("tableName", tableName);
			resultList = pgmDao.selectLayerTableColumns(param); // attr, type
			
			if(resultList != null && resultList.size()>0) {
				resultJSON.put("Code", 100);
				resultJSON.put("Message", Message.code100);
				resultJSON.put("Data", tableName);
			}else {
				resultJSON.put("Code", 200);
				resultJSON.put("Message", Message.code200);
			}
		} catch (Exception e) {
			e.printStackTrace();
			resultJSON.put("Code", 800);
			resultJSON.put("Message", Message.code800);
		}
		
		return callback + "(" + resultJSON.toString() + ")";
	}
	
	@RequestMapping(value = "/pgm/updateLayer/{tableName}/{tableType}", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String updateLayerService(@RequestParam("callback") String callback
			, @PathVariable("tableName") String tableName
			, @PathVariable("tableType") String tableType
			, Model model, HttpServletRequest request, HttpServletResponse response) {
		response .setHeader("Access-Control-Allow-Methods" , "POST, GET, OPTIONS, DELETE" );
		response.setHeader( "Access-Control-Max-Age" , "3600" );
		response.setHeader( "Access-Control-Allow-Headers" , "x-requested-with" );
		response.setHeader( "Access-Control-Allow-Origin" , "*" );

		JSONObject resultJSON = new JSONObject();
		
		try {
			if(tableName == null || tableName == "" || tableName == "null"){
				resultJSON.put("Code", 600);
				resultJSON.put("Message", Message.code600);
			}
				
			DefaultTransactionDefinition def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
			JdbcTemplate template = new JdbcTemplate(dataSource);
			DataSourceTransactionManager txManager = new DataSourceTransactionManager(dataSource);
			TransactionStatus sts = txManager.getTransaction(def);
			
			try{
				boolean chkVideo = false;
				String videoCommand = "";
				boolean chkPhoto = false;
				String photoCommand = "";
				boolean chkSensor = false;
				String sensorCommand = "";
				boolean chkTraj = false;
				String trajCommand = "";
				
				List<String> sensorList = new ArrayList<String>();
				sensorList.add("accx");
				sensorList.add("accy");
				sensorList.add("accz");
				sensorList.add("gyrox");
				sensorList.add("gyroy");
				sensorList.add("gyroz");
				
				tableName = dataReplaceFun(tableName);
				
				// 테이블명 변경
				Map<String, String> param = new HashMap<String, String>();
				param.put("projectId", tableName.split("_")[1]);
				String oriTableName = pgmDao.getLayerTableName(param);
				
				if (!oriTableName.equalsIgnoreCase(tableName)) {
					template.execute("ALTER TABLE " + oriTableName + " RENAME TO " + tableName + ";");
				}
				
				if(tableType != null && !"".equals(tableType) && !"null".equals(tableType)){
					ObjectMapper m = new ObjectMapper();
					try{
						List<HashMap<String, String>> saveAttrList = m.readValue(tableType, new TypeReference<List<HashMap<String, String>>>() { });
						
						// 삭제를 먼저 하기 위해 insert나 update는 따로 저장해놓는다.
						List<String> insertQueryList = new ArrayList<String>();
						List<String> updateQueryList = new ArrayList<String>();
						
						// 일반 컬럼 추가/수정/삭제
						for (HashMap<String, String> saveAttrMap : saveAttrList) {
							String attribute = saveAttrMap.get("attribute");
							String oriAttribute = saveAttrMap.get("oriAttribute");
							String type = saveAttrMap.get("type");
							String oriType = saveAttrMap.get("oriType");
							String command = saveAttrMap.get("command");
							
							if ("video".equalsIgnoreCase(type)) {
								chkVideo = true;
								videoCommand = command;
							} else if ("photo".equalsIgnoreCase(type)) {
								chkPhoto = true;
								photoCommand = command;
							} else if ("sensor".equalsIgnoreCase(type)) {
								chkSensor = true;
								sensorCommand = command;
							} else if ("traj".equalsIgnoreCase(type)) {
								chkTraj = true;
								trajCommand = command;
							} else {
								if ("INSERT".equalsIgnoreCase(command)) {
									// 추가
									insertQueryList.add("ALTER TABLE " + tableName + " ADD COLUMN " + attribute + " " + type + ";");
//									template.execute("ALTER TABLE " + tableName + " ADD COLUMN " + attribute + " " + type + ";");
								} else if ("UPDATE".equalsIgnoreCase(command)) {
									// 수정 - 타입과 컬럼명을 확인한다.
									if (!type.equalsIgnoreCase(oriType)) {
										// 타입이 같지 않으면, 오류
										resultJSON.put("Code", 301);
										resultJSON.put("Message", Message.code300);
										return callback + "(" + resultJSON.toString() + ")";
									} else {
										if (!oriAttribute.equalsIgnoreCase(attribute)) {
											// 컬럼명 업데이트 수행
//											template.execute("ALTER TABLE " + tableName + " RENAME COLUMN " + oriAttribute + " TO " + attribute + ";");
											updateQueryList.add("ALTER TABLE " + tableName + " RENAME COLUMN " + oriAttribute + " TO " + attribute + ";");
										}
									}
								} else if ("DELETE".equalsIgnoreCase(command)) {
									// 삭제
									if (oriAttribute != null && oriAttribute.length() > 0) {
										template.execute("ALTER TABLE " + tableName + " DROP COLUMN " + oriAttribute + ";");
									}
								}
							}
						}
						
						if (updateQueryList.size() > 0) {
							for (String updateQuery : updateQueryList) {
								template.execute(updateQuery);
							}
						}
						
						if (insertQueryList.size() > 0) {
							for (String insertQuery : insertQueryList) {
								template.execute(insertQuery);
							}
						}
						
						if (chkVideo) {
							String columnSql = "";
							if ("INSERT".equalsIgnoreCase(videoCommand)) {
								columnSql = "select addmgeometrycolumn ('public', '" + tableName + "', 'mv', 4326, 'mvideo', 2, 3000);";
								template.execute(columnSql);
							} else if ("UPDATE".equalsIgnoreCase(videoCommand)) {
								// 업데이트는 없음
							} else if ("DELETE".equalsIgnoreCase(videoCommand)) {
								List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();
								Map<String, String> paramMap = new HashMap<String, String>();
								
								// 1. table 에서 컬럼 삭제
								template.execute("ALTER TABLE " + tableName + " DROP COLUMN mv;");
								
								// 2. mgeometry_columns에서 테이블 조회
								paramMap.put("tableName", tableName);
								paramMap.put("columnType", "mvideo");
								resultList = pgmDao.getMgeometryColumns(paramMap);
								
								// 3. 조회된 table 삭제, mgeometry_columns의 행 삭제
								for (Map<String, String> resultMap : resultList) {
									String resultId = resultMap.get("id");
									String resultTableName = resultMap.get("table_name");
									
									// 조회된 table 삭제
									if (resultTableName != null && resultTableName.length() > 0) {
										template.execute("DROP TABLE IF EXISTS " + resultTableName + ";");
									}
									// mgeometry_columns의 행 삭제
									if (resultId != null && resultId.length() > 0) {
										template.execute("DELETE FROM mgeometry_columns WHERE f_segtableoid = '" + resultId + "';");
									}
								}
							}
						}
						
						if (chkPhoto) {
							String columnSql = "";
							if ("INSERT".equalsIgnoreCase(photoCommand)) {
								columnSql = "select addmgeometrycolumn ('public', '" + tableName + "', 'st', 4326, 'stphoto', 2, 1);";
								template.execute(columnSql);
							} else if ("UPDATE".equalsIgnoreCase(photoCommand)) {
								// 업데이트는 없음
							} else if ("DELETE".equalsIgnoreCase(photoCommand)) {
								List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();
								Map<String, String> paramMap = new HashMap<String, String>();
								
								// 1. table 에서 컬럼 삭제
								template.execute("ALTER TABLE " + tableName + " DROP COLUMN st;");
								
								// 2. mgeometry_columns에서 테이블 조회
								paramMap.put("tableName", tableName);
								paramMap.put("columnType", "stphoto");
								resultList = pgmDao.getMgeometryColumns(paramMap);
								
								// 3. 조회된 table 삭제, mgeometry_columns의 행 삭제
								for (Map<String, String> resultMap : resultList) {
									String resultId = resultMap.get("id");
									String resultTableName = resultMap.get("table_name");
									
									// 조회된 table 삭제
									if (resultTableName != null && resultTableName.length() > 0) {
										template.execute("DROP TABLE IF EXISTS " + resultTableName + ";");
									}
									// mgeometry_columns의 행 삭제
									if (resultId != null && resultId.length() > 0) {
										template.execute("DELETE FROM mgeometry_columns WHERE f_segtableoid = '" + resultId + "';");
									}
								}
							}
						}
						
						if (chkSensor) {
							if ("INSERT".equalsIgnoreCase(sensorCommand)) {
								for (String sensor : sensorList) {
									String addColumnSql = "select addmgeometrycolumn ('public', '" + tableName + "', '" + sensor + "', 4326, 'mdouble', 2, 3000);";
									template.execute(addColumnSql);
								}
							} else if ("UPDATE".equalsIgnoreCase(sensorCommand)) {
								// 업데이트는 없음
							} else if ("DELETE".equalsIgnoreCase(sensorCommand)) {
								List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();
								Map<String, String> paramMap = new HashMap<String, String>();
								
								// 1. table 에서 컬럼 삭제
								for (String sensor : sensorList) {
									template.execute("ALTER TABLE " + tableName + " DROP COLUMN " + sensor + ";");
								}
								
								// 2. mgeometry_columns에서 테이블 조회
								paramMap.put("tableName", tableName);
								paramMap.put("columnType", "mdouble");
								resultList = pgmDao.getMgeometryColumns(paramMap);
								
								// 3. 조회된 table 삭제, mgeometry_columns의 행 삭제
								for (Map<String, String> resultMap : resultList) {
									String resultId = resultMap.get("id");
									String resultTableName = resultMap.get("table_name");
									
									// 조회된 table 삭제
									if (resultTableName != null && resultTableName.length() > 0) {
										template.execute("DROP TABLE IF EXISTS " + resultTableName + ";");
									}
									// mgeometry_columns의 행 삭제
									if (resultId != null && resultId.length() > 0) {
										template.execute("DELETE FROM mgeometry_columns WHERE f_segtableoid = '" + resultId + "';");
									}
								}
							}
						}
						
						if (chkTraj) {
							String columnSql = "";
							if ("INSERT".equalsIgnoreCase(trajCommand)) {
								columnSql = "select addmgeometrycolumn ('public', '" + tableName + "', 'mt', 4326, 'mpoint', 2, 50);";
								template.execute(columnSql);
							} else if ("UPDATE".equalsIgnoreCase(trajCommand)) {
								// 업데이트는 없음
							} else if ("DELETE".equalsIgnoreCase(trajCommand)) {
								List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();
								Map<String, String> paramMap = new HashMap<String, String>();
								
								// 1. table 에서 컬럼 삭제
								template.execute("ALTER TABLE " + tableName + " DROP COLUMN mt;");
								
								// 2. mgeometry_columns에서 테이블 조회
								paramMap.put("tableName", tableName);
								paramMap.put("columnType", "mpoint");
								resultList = pgmDao.getMgeometryColumns(paramMap);
								
								// 3. 조회된 table 삭제, mgeometry_columns의 행 삭제
								for (Map<String, String> resultMap : resultList) {
									String resultId = resultMap.get("id");
									String resultTableName = resultMap.get("table_name");
									
									// 조회된 table 삭제
									if (resultTableName != null && resultTableName.length() > 0) {
										template.execute("DROP TABLE IF EXISTS " + resultTableName + ";");
									}
									// mgeometry_columns의 행 삭제
									if (resultId != null && resultId.length() > 0) {
										template.execute("DELETE FROM mgeometry_columns WHERE f_segtableoid = '" + resultId + "';");
									}
								}
							}
						}
						
						resultJSON.put("Code", 100);
						resultJSON.put("Message", Message.code100);
					}catch(Exception e){
						resultJSON.put("Code", 600);
						resultJSON.put("Message", Message.code600);
					}
				}
				
				txManager.commit(sts);
			}catch(Exception e){
				e.printStackTrace();
				txManager.rollback(sts);
				resultJSON.put("Code", 800);
				resultJSON.put("Message", Message.code800);
			}
		} catch (Exception e) {
			e.printStackTrace();
			resultJSON.put("Code", 800);
			resultJSON.put("Message", Message.code800);
		}
		
		return callback + "(" + resultJSON.toString() + ")";
	}
	
	@RequestMapping(value = "/pgm/removeLayer/{projectId}", method = RequestMethod.GET, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String removeLayerService(@RequestParam("callback") String callback
			, @PathVariable("projectId") String projectId
			, Model model, HttpServletRequest request, HttpServletResponse response) {
		response .setHeader("Access-Control-Allow-Methods" , "POST, GET, OPTIONS, DELETE" );
		response.setHeader( "Access-Control-Max-Age" , "3600" );
		response.setHeader( "Access-Control-Allow-Headers" , "x-requested-with" );
		response.setHeader( "Access-Control-Allow-Origin" , "*" );

		JSONObject resultJSON = new JSONObject();
		
		try {
			if(projectId == null || projectId == "" || projectId == "null"){
				resultJSON.put("Code", 600);
				resultJSON.put("Message", Message.code600);
			}
				
			DefaultTransactionDefinition def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
			JdbcTemplate template = new JdbcTemplate(dataSource);
			DataSourceTransactionManager txManager = new DataSourceTransactionManager(dataSource);
			TransactionStatus sts = txManager.getTransaction(def);
			
			try{
				List<String> sensorList = new ArrayList<String>();
				sensorList.add("accx");
				sensorList.add("accy");
				sensorList.add("accz");
				sensorList.add("gyrox");
				sensorList.add("gyroy");
				sensorList.add("gyroz");
				
				projectId = dataReplaceFun(projectId);
				
				// 테이블명 변경
				Map<String, String> param = new HashMap<String, String>();
				param.put("projectId", projectId);
				String tableName = pgmDao.getLayerTableName(param);
				
				if (tableName != null && tableName.length() > 0) {
					template.execute("DROP TABLE IF EXISTS " + tableName + ";");
					
					List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();
					// 1. mgeometry_columns에서 테이블 조회
					param.put("tableName", tableName);
					resultList = pgmDao.getMgeometryColumns(param);
					
					// 2. 조회된 table 삭제, mgeometry_columns의 행 삭제
					for (Map<String, String> resultMap : resultList) {
						String resultId = resultMap.get("id");
						String resultTableName = resultMap.get("table_name");
						
						// 조회된 table 삭제
						if (resultTableName != null && resultTableName.length() > 0) {
							template.execute("DROP TABLE IF EXISTS " + resultTableName + ";");
						}
						// mgeometry_columns의 행 삭제
						if (resultId != null && resultId.length() > 0) {
							template.execute("DELETE FROM mgeometry_columns WHERE f_segtableoid = '" + resultId + "';");
						}
					}
				}
				
				resultJSON.put("Code", 100);
				resultJSON.put("Message", Message.code100);
			}catch(Exception e){
				resultJSON.put("Code", 600);
				resultJSON.put("Message", Message.code600);
			}
			
			txManager.commit(sts);
		} catch (Exception e) {
			e.printStackTrace();
			resultJSON.put("Code", 800);
			resultJSON.put("Message", Message.code800);
		}
		
		return callback + "(" + resultJSON.toString() + ")";
	}
	
	@RequestMapping(value = "/pgm/tableviewDataList/{projectIdx}", produces="application/json;charset=UTF-8")
	@ResponseBody
	public String tableviewDataList(@RequestParam("callback") String callback,
			@PathVariable("projectIdx") String projectIdx
			, Model model, HttpServletRequest request) {
		JSONObject resultJSON = new JSONObject();
		List<HashMap<String, Object>> resultList = new ArrayList<HashMap<String, Object>>();
		DataTableUtil dataTable = new DataTableUtil();
		
		int total = 0;
		Map<String, Object> mapReturn = new HashMap<String, Object>();
		try {
			//get Base
			Map<String, String> param = new HashMap<String, String>();
			param.put("projectIdx", projectIdx);
			//param.put("tableName", tableName);
			//Map map = dataTable.makeSearchMap(request);
			resultList = pgmDao.tableviewDataList(param); // attr, type
			
			if(resultList != null && resultList.size()>0) {
				//resultJSON.put("Code", 100);
				//resultJSON.put("Message", Message.code100);
				//resultJSON.put("Data", resultList);
				if (resultList != null)
				{
					if (resultList.size() > 0)
					{
						String totalStr = String.valueOf(resultList.get(0).get("total"));
						if (totalStr != null && !"".equals(totalStr) && !"null".equals(totalStr))
						{
							total = Integer.parseInt(totalStr);
						}
					}
				}

				mapReturn.put("draw", 1);
				mapReturn.put("recordsTotal", total);
				mapReturn.put("recordsFiltered", total);
				mapReturn.put("data", resultList);
			}else {
				resultJSON.put("Code", 200);
				resultJSON.put("Message", Message.code200);
			}
		} catch (Exception e) {
			e.printStackTrace();
			resultJSON.put("Code", 800);
			resultJSON.put("Message", Message.code800);
		}
		
		resultJSON.put("jsonView", mapReturn);
		
		/*ModelAndView modelView = new ModelAndView();
		modelView = dataTable.makeDataTable(resultList);*/
		return resultJSON.toString();
	}
	
	
	@RequestMapping(value = "/pgm/tableviewDataDoubleList/{projectIdx}", produces="application/json;charset=UTF-8")
	@ResponseBody
	public String tableviewDataDoubleList(@RequestParam("callback") String callback,
			@PathVariable("projectIdx") String projectIdx
			, Model model, HttpServletRequest request) {
		JSONObject resultJSON = new JSONObject();
		List<HashMap<String, Object>> resultList = new ArrayList<HashMap<String, Object>>();
		List<Map<String, String>> resultList2 = new ArrayList<Map<String, String>>();
		DataTableUtil dataTable = new DataTableUtil();
		
		int total = 0;
		Map<String, Object> mapReturn = new HashMap<String, Object>();
		try {
			//get Base
			Map<String, String> param = new HashMap<String, String>();
			param.put("projectId", projectIdx);
			String tableName = pgmDao.getLayerTableName(param);
			param.put("tableName", tableName);
			//param.put("tableName", tableName);
			//Map map = dataTable.makeSearchMap(request);
			resultList2 = pgmDao.selectLayerTableAttrs(param);
			resultList = pgmDao.tableviewDataList(param); // attr, type
			
			if(resultList2 != null && resultList2.size()>0) {
				//resultJSON.put("Code", 100);
				//resultJSON.put("Message", Message.code100);
				//resultJSON.put("Data", resultList);
				/*if (resultList != null)
				{
					if (resultList.size() > 0)
					{
						String totalStr = String.valueOf(resultList.get(0).get("total"));
						if (totalStr != null && !"".equals(totalStr) && !"null".equals(totalStr))
						{
							total = Integer.parseInt(totalStr);
						}
					}
				}*/

//				resultJSON.put("draw", 1);
//				resultJSON.put("recordsTotal", total);
//				resultJSON.put("recordsFiltered", total);
				resultJSON.put("data", resultList);
				resultJSON.put("columns", resultList2);
				resultJSON.put("tableName", tableName);
			}else {
				resultJSON.put("Code", 200);
				resultJSON.put("Message", Message.code200);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			resultJSON.put("Code", 800);
			resultJSON.put("Message", Message.code800);
		}
		
//		resultJSON.put("jsonView", mapReturn);
//		String resultStr = resultJSON.toString();
//		String mapReturnStr = mapReturn.toString();
		
//		ModelAndView modelView = new ModelAndView();
//		modelView = dataTable.makeDataTable(resultList);
		
		return resultJSON.toString();
	}
	@RequestMapping(value = "/pgm/tableRowDelete/{projectIdx}/{rowIdx}", produces="application/json;charset=UTF-8")
	@ResponseBody
	public String tableRowDelete(@RequestParam("callback") String callback,
			@PathVariable("projectIdx") String projectIdx,
			@PathVariable("rowIdx") String rowIdx
			, Model model, HttpServletRequest request) {
		JSONObject resultJSON = new JSONObject();
		List<HashMap<String, Object>> resultList = new ArrayList<HashMap<String, Object>>();
		DataTableUtil dataTable = new DataTableUtil();
		
		int total = 0;
		Map<String, Object> mapReturn = new HashMap<String, Object>();
		try {
			//get Base
			Map<String, String> param = new HashMap<String, String>();
			param.put("projectId", projectIdx);
			param.put("rowIdx", rowIdx);
			String tableName = pgmDao.getLayerTableName(param);
			param.put("tableName", tableName);
			//param.put("tableName", tableName);
			//Map map = dataTable.makeSearchMap(request);
			int a = pgmDao.tableRowDelete(param); // attr, type
			
			if(a > 0)
			{
				resultJSON.put("Code", 100);
				resultJSON.put("Message", Message.code100);
			}
			
			/*if(resultList != null && resultList.size()>0) {
				//resultJSON.put("Code", 100);
				//resultJSON.put("Message", Message.code100);
				//resultJSON.put("Data", resultList);
				if (resultList != null)
				{
					if (resultList.size() > 0)
					{
						String totalStr = String.valueOf(resultList.get(0).get("total"));
						if (totalStr != null && !"".equals(totalStr) && !"null".equals(totalStr))
						{
							total = Integer.parseInt(totalStr);
						}
					}
				}
				
//				resultJSON.put("draw", 1);
//				resultJSON.put("recordsTotal", total);
//				resultJSON.put("recordsFiltered", total);
			}*/
			
			else 
			{
				resultJSON.put("Code", 200);
				resultJSON.put("Message", Message.code200);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			resultJSON.put("Code", 800);
			resultJSON.put("Message", Message.code800);
		}
		
//		resultJSON.put("jsonView", mapReturn);
//		String resultStr = resultJSON.toString();
//		String mapReturnStr = mapReturn.toString();
		
//		ModelAndView modelView = new ModelAndView();
//		modelView = dataTable.makeDataTable(resultList);
		
		return resultJSON.toString();
	}
	
	@RequestMapping(value = "/pgm/addPgmVideoLayer/{data}", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String addPgmVideoLayer(@RequestParam("callback") String callback
			, @PathVariable("data") String data
			, Model model, HttpServletRequest request, HttpServletResponse response) {
		response .setHeader("Access-Control-Allow-Methods" , "POST, GET, OPTIONS, DELETE" );
		response.setHeader( "Access-Control-Max-Age" , "3600" );
		response.setHeader( "Access-Control-Allow-Headers" , "x-requested-with" );
		response.setHeader( "Access-Control-Allow-Origin" , "*" );

		JSONObject resultJSON = new JSONObject();
		
		try {
			if(data == null || data == "" || data == "null"){
				resultJSON.put("Code", 600);
				resultJSON.put("Message", Message.code600);
			}
				
			DefaultTransactionDefinition def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
			JdbcTemplate template = new JdbcTemplate(dataSource);
			DataSourceTransactionManager txManager = new DataSourceTransactionManager(dataSource);
			TransactionStatus sts = txManager.getTransaction(def);
			String logKey = "";
			try{
				List<String> sensorList = new ArrayList<String>();
				sensorList.add("accx");
				sensorList.add("accy");
				sensorList.add("accz");
				sensorList.add("gyrox");
				sensorList.add("gyroy");
				sensorList.add("gyroz");
				
				ObjectMapper m = new ObjectMapper();
				try{
					HashMap<String, Object> dataMap = m.readValue(data, new TypeReference<HashMap<String, Object>>() { });
					
					ArrayList<FileItem> fileItemList = new ArrayList<FileItem>();
					List<Map<String, String>> files = new ArrayList<Map<String, String>>();
					ArrayList<String> filesXml = new ArrayList<String>();
					Map<String, String> param2 = new HashMap<String, String>();
					
					Map<String,String> filesMap = new HashMap<String, String>();
					FileItem item = null;
					String tableName = "";
					String colName = "";
					String whereName = " WHERE ";
					if (dataMap != null) {
						Map<String, Object> inputAttrData = (Map<String, Object>) dataMap.get("inputAttrData");
						// insert table
						String projectId = (String) dataMap.get("projectId");
						logKey = (String) dataMap.get("logKey");
						
						Map<String, String> param = new HashMap<String, String>();
						param.put("projectId", projectId);
						tableName = pgmDao.getLayerTableName(param);
						colName = pgmDao.getLayerColName(param);
						String insertSql = "INSERT INTO " + tableName;
						String keySql = " (";
						String valueSql = " (";
						int index = 0;
						// {id=123, name=1234}
						Set<String> keySet = inputAttrData.keySet();
						for (String key : keySet) {
							keySql += key + ",";
							valueSql += "'" + inputAttrData.get(key) + "',";
							if(index == 0)
							{
								whereName += " "+key+" = "+ inputAttrData.get(key);
								index++;
							}
							else
							{
								index++;
							}
						}
						
						
						keySql = keySql.substring(0, keySql.length() - 1);
						valueSql = valueSql.substring(0, valueSql.length() - 1);
						
						keySql += ")";
						valueSql += ");";
						
						template.execute(insertSql + keySql + " VALUES " + valueSql);
						
						//파일 정보 저장 변수
						boolean isMultipart = ServletFileUpload.isMultipartContent(request); // 멀티파트인지 체크
						File tempDir = null;
						File uploadDir = null;
						File saveUserPathDir = null;
						
						String fileName = "";
						
						if(isMultipart) {
							String saveUserPath = request.getSession().getServletContext().getRealPath("/");
							saveUserPath = saveUserPath.substring(0, saveUserPath.lastIndexOf("GeoCMS_Gateway")) + "GeoCMS"+ 
								saveUserPath.substring(saveUserPath.lastIndexOf("GeoCMS_Gateway")+14) +
								File.separator + "upload";
							
							saveUserPathDir = new File(saveUserPath);
							if(!saveUserPathDir.exists()) saveUserPathDir.mkdir();
							
							int uploadMaxSize = 2*1024*1024*1024; //1024MB = 1GB
							tempDir = new File(saveUserPath+"/"+"tmp");
							uploadDir = new File(saveUserPath);
							 
							if(!tempDir.exists()) tempDir.mkdir();
							if(!uploadDir.exists()) uploadDir.mkdir();
							
							uploadDir = new File(saveUserPath+"/pgmVideo");
							if(!uploadDir.exists()) uploadDir.mkdir();
							
							DiskFileItemFactory factory = new DiskFileItemFactory(uploadMaxSize, tempDir);
							ServletFileUpload upload = new ServletFileUpload(factory);
							
							upload.setSizeMax(uploadMaxSize);
							List items = upload.parseRequest(request);
							Iterator iter = items.iterator();
							
							String changeFileName = "";
							int gpxFileIndex = 1;
							File uploadFile = null;
							String oldSubfix = "";
							File tmpGpxFilePathDir = uploadDir;
							String tmpGpxFilePath = "";
							String tmpGpxFileName = "";
							String prefix = "";
							String suffix = "";
							String tmpPathStr = "";
							String oneSubFix = "";
							HashMap<String, Object> childParam = new HashMap<String, Object>();
							
							while(iter.hasNext()) {
								filesMap = new HashMap<String, String>();
								gpxFileIndex = 1;
								uploadFile = null;
								changeFileName = "";
								tmpGpxFilePath = "";
								tmpGpxFileName = "";
								prefix = "";
								suffix = "";
								oldSubfix = "";
								tmpPathStr = "";
								oneSubFix = "";
								
								item = (FileItem)iter.next();
								if(!item.isFormField()) {
									fileName = item.getName();
									
									if(fileName.indexOf(".gpx") > 0 || fileName.indexOf(".GPX") > 0) {
										fileItemList.add(item);
										tmpGpxFilePath = tmpGpxFilePathDir + File.separator + fileName;
										tmpGpxFileName = tmpGpxFilePath.substring(0, tmpGpxFilePath.lastIndexOf("."))+"_mp4.gpx";
										prefix = tmpGpxFilePath.substring(0, tmpGpxFilePath.lastIndexOf("."));
										uploadFile  = new File(tmpGpxFilePath);
										
										while((uploadFile = new File(tmpGpxFileName)).exists()) {
											suffix = "_mp4.gpx";
											tmpGpxFileName = prefix+"("+gpxFileIndex+")"+suffix;
											gpxFileIndex++;
											uploadFile = new File(tmpGpxFileName);
										}
										
										filesMap.put("file", tmpGpxFileName);
										filesMap.put("idx", null);
										files.add(filesMap);
										filesXml.add(tmpGpxFileName);
									}
								}
							}
						}
					}
					
					String tmpGpxFilePathDir = "";
					String nowFileName = "";
					
					for(int j=0; j<fileItemList.size(); j++){
						item = fileItemList.get(j);
						
						if(!item.isFormField()) {
							String fileName = item.getName();
							System.out.println("FileName : "+fileName);
							if(fileName != null && !"".equals(fileName)){
								Map<String, String> fileMap = files.get(j);
								String tmpGpxFilePathDirFull = String.valueOf(fileMap.get("file"));
								tmpGpxFilePathDir = tmpGpxFilePathDirFull.substring(0, tmpGpxFilePathDirFull.lastIndexOf(File.separator));
								nowFileName = tmpGpxFilePathDirFull.substring(tmpGpxFilePathDirFull.lastIndexOf(File.separator)+1);
								File newLogKeyPath = new File(tmpGpxFilePathDir);
								if(!newLogKeyPath.exists()) newLogKeyPath.mkdir();
								
								System.out.println("nowFileName : "+nowFileName);
								
								if(fileName.indexOf(".gpx") >= 0){
									item.write(new File(tmpGpxFilePathDir + File.separator + nowFileName));
								}
							}
						}
					}
					String saveUserPath = request.getSession().getServletContext().getRealPath("/");
					saveUserPath = saveUserPath.substring(0, saveUserPath.lastIndexOf("GeoCMS_Gateway")) + "GeoCMS"+ 
							saveUserPath.substring(saveUserPath.lastIndexOf("GeoCMS_Gateway")+14) +
							File.separator + "upload"+ File.separator + "GeoVideo";
					String fileName = (String) dataMap.get("fileName");
					String ext = (String) dataMap.get("ext");
					// gps file
					if (fileName != null && fileName.length() > 0) {
						fileName = fileName + "_"+ ext +".gpx";
					}
					// read uploaded file
					DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
					dbf.setIgnoringElementContentWhitespace(true);
					DocumentBuilder db = dbf.newDocumentBuilder();
					
					Document firstDoc = db.parse(new File(tmpGpxFilePathDir + File.separator + nowFileName));
					NodeList nList1 = firstDoc.getElementsByTagName("trkpt");
					NodeList nList2 = firstDoc.getElementsByTagName("time");
					System.out.println("nList1 : "+ nList1.getLength());
					System.out.println("nList2 : "+ nList2.getLength());
					
					JSONArray jsonArr = new JSONArray();
					JSONObject jsonObj = new JSONObject();
					
					
					String latitude = "0";
					String longitude = "0";
					String updateVideo = "update "+tableName;
					String url = saveUserPath + File.separator + fileName;
					String mvideo = " SET "+colName+" = append("+colName+", 'MVIDEO ("+ url + ", MPOINT (";
					String mframe = "";
					
					if(nList1 != null && nList1.getLength() > 0){
						for(int j=0; j<nList1.getLength(); j++){
							HashMap<String, String> resultMap = new HashMap<String, String>();
							Element eElement = (Element)nList1.item(j);
							Element eElement2 = (Element)nList2.item(j);
							String time = eElement2.getFirstChild().getNodeValue();
							time = time.replace("T", " ");
							time = time.replace("Z", "");
							SimpleDateFormat transformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
							Date date = transformat.parse(time);
							long timest = date.getTime();
							timest = timest+32400000;
							latitude = eElement.getAttribute("lat");
							longitude = eElement.getAttribute("lon");
							System.out.println("latitude : " + latitude + " longitude : " + longitude);
							JSONObject chJsonObj = new JSONObject();
							chJsonObj.put("lat",latitude);
							chJsonObj.put("lon",longitude);
							jsonArr.add(chJsonObj);
							resultMap.put("lat",latitude);
							resultMap.put("lon",longitude);
							
							mvideo += "("+latitude+" "+longitude+") "+timest+", ";
							mframe += "(-1 -1 -1 -1 -1), ";
						}
					}
					mvideo += "), FRAME (";
					mframe = mframe.substring(0, mframe.length() - 2);
					mvideo += mframe;
					mvideo += " ))')";
					
					jsonObj.put("gpsData", jsonArr);
					//param2.put("fileName", fileName);
					param2.put("gpsData", jsonObj.toString());
					param2.put("idx", logKey);
					template.execute(updateVideo + mvideo + whereName);
					
					int p = pgmDao.updateVideoData(param2);
					resultJSON.put("Code", 100);
					resultJSON.put("Message", Message.code100);
				}catch(Exception e){
					resultJSON.put("Code", 600);
					resultJSON.put("Message", Message.code600);
				}
				
				txManager.commit(sts);
			}catch(Exception e){
				e.printStackTrace();
				txManager.rollback(sts);
				resultJSON.put("Code", 800);
				resultJSON.put("Message", Message.code800);
			}
		} catch (Exception e) {
			e.printStackTrace();
			resultJSON.put("Code", 800);
			resultJSON.put("Message", Message.code800);
		}
		
		return callback + "(" + resultJSON.toString() + ")";
	}
	@RequestMapping(value = "/pgm/addPgmTrajLayer/{data}", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String addPgmTrajLayer(@RequestParam("callback") String callback
			, @PathVariable("data") String data
			, Model model, HttpServletRequest request, HttpServletResponse response) {
		response .setHeader("Access-Control-Allow-Methods" , "POST, GET, OPTIONS, DELETE" );
		response.setHeader( "Access-Control-Max-Age" , "3600" );
		response.setHeader( "Access-Control-Allow-Headers" , "x-requested-with" );
		response.setHeader( "Access-Control-Allow-Origin" , "*" );
		
		JSONObject resultJSON = new JSONObject();
		
		try {
			if(data == null || data == "" || data == "null"){
				resultJSON.put("Code", 600);
				resultJSON.put("Message", Message.code600);
			}
			
			DefaultTransactionDefinition def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
			JdbcTemplate template = new JdbcTemplate(dataSource);
			DataSourceTransactionManager txManager = new DataSourceTransactionManager(dataSource);
			TransactionStatus sts = txManager.getTransaction(def);
			
			try{
				List<String> sensorList = new ArrayList<String>();
				sensorList.add("accx");
				sensorList.add("accy");
				sensorList.add("accz");
				sensorList.add("gyrox");
				sensorList.add("gyroy");
				sensorList.add("gyroz");
				
				ObjectMapper m = new ObjectMapper();
				try{
					HashMap<String, Object> dataMap = m.readValue(data, new TypeReference<HashMap<String, Object>>() { });
					
					ArrayList<FileItem> fileItemList = new ArrayList<FileItem>();
					List<Map<String, String>> files = new ArrayList<Map<String, String>>();
					ArrayList<String> filesXml = new ArrayList<String>();
					Map<String, String> param = new HashMap<String, String>();
					Map<String, String> param2 = new HashMap<String, String>();
					Map<String,String> filesMap = new HashMap<String, String>();
					FileItem item = null;
					String logKey = "";
					String projectId = "";
					String tableName = "";
					String colName = "";
					String whereName = "WHERE ";
					if (dataMap != null) {
						Map<String, Object> inputAttrData = (Map<String, Object>) dataMap.get("inputAttrData");
						// insert table
						projectId = (String) dataMap.get("projectId");
						logKey = (String) dataMap.get("logKey");
						
						
						param.put("projectId", projectId);
						tableName = pgmDao.getLayerTableName(param);
						colName = pgmDao.getLayerColName(param);
						String insertSql = "INSERT INTO " + tableName;
						String keySql = " (";
						String valueSql = " (";
						int index = 0;
						// {id=123, name=1234}
						Set<String> keySet = inputAttrData.keySet();
						for (String key : keySet) {
							keySql += key + ",";
							valueSql += "'" + inputAttrData.get(key) + "',";
							
							if(index == 0)
							{
								whereName  += " "+key+" = "+ inputAttrData.get(key);
								index++;
							}
							else
							{
								index++;
							}
							
						}
						
						
						keySql = keySql.substring(0, keySql.length() - 1);
						valueSql = valueSql.substring(0, valueSql.length() - 1);
						
						keySql += ")";
						valueSql += ");";
						
						template.execute(insertSql + keySql + " VALUES " + valueSql);
						
						//파일 정보 저장 변수
						boolean isMultipart = ServletFileUpload.isMultipartContent(request); // 멀티파트인지 체크
						File tempDir = null;
						File uploadDir = null;
						File saveUserPathDir = null;
						
						String fileName = "";
						
						if(isMultipart) {
							String saveUserPath = request.getSession().getServletContext().getRealPath("/");
							saveUserPath = saveUserPath.substring(0, saveUserPath.lastIndexOf("GeoCMS_Gateway")) + "GeoCMS"+ 
									saveUserPath.substring(saveUserPath.lastIndexOf("GeoCMS_Gateway")+14) +
									File.separator + "upload";
							
							saveUserPathDir = new File(saveUserPath);
							if(!saveUserPathDir.exists()) saveUserPathDir.mkdir();
							
							int uploadMaxSize = 2*1024*1024*1024; //1024MB = 1GB
							tempDir = new File(saveUserPath+"/"+"tmp");
							uploadDir = new File(saveUserPath);
							
							if(!tempDir.exists()) tempDir.mkdir();
							if(!uploadDir.exists()) uploadDir.mkdir();
							
							uploadDir = new File(saveUserPath+"/pgmTraj");
							if(!uploadDir.exists()) uploadDir.mkdir();
							
							DiskFileItemFactory factory = new DiskFileItemFactory(uploadMaxSize, tempDir);
							ServletFileUpload upload = new ServletFileUpload(factory);
							
							upload.setSizeMax(uploadMaxSize);
							List items = upload.parseRequest(request);
							Iterator iter = items.iterator();
							
							String changeFileName = "";
							int gpxFileIndex = 1;
							File uploadFile = null;
							String oldSubfix = "";
							File tmpGpxFilePathDir = uploadDir;
							String tmpGpxFilePath = "";
							String tmpGpxFileName = "";
							String prefix = "";
							String suffix = "";
							String tmpPathStr = "";
							String oneSubFix = "";
							HashMap<String, Object> childParam = new HashMap<String, Object>();
							
							while(iter.hasNext()) {
								filesMap = new HashMap<String, String>();
								gpxFileIndex = 1;
								uploadFile = null;
								changeFileName = "";
								tmpGpxFilePath = "";
								tmpGpxFileName = "";
								prefix = "";
								suffix = "";
								oldSubfix = "";
								tmpPathStr = "";
								oneSubFix = "";
								
								item = (FileItem)iter.next();
								if(!item.isFormField()) {
									fileName = item.getName();
									
									if(fileName.indexOf(".gpx") > 0 || fileName.indexOf(".GPX") > 0) {
										fileItemList.add(item);
										tmpGpxFilePath = tmpGpxFilePathDir + File.separator + fileName;
										tmpGpxFileName = tmpGpxFilePath.substring(0, tmpGpxFilePath.lastIndexOf("."))+"_mp4.gpx";
										prefix = tmpGpxFilePath.substring(0, tmpGpxFilePath.lastIndexOf("."));
										uploadFile  = new File(tmpGpxFilePath);
										
										while((uploadFile = new File(tmpGpxFileName)).exists()) {
											suffix = "_gpx.gpx";
											tmpGpxFileName = prefix+"("+gpxFileIndex+")"+suffix;
											gpxFileIndex++;
											uploadFile = new File(tmpGpxFileName);
										}
										
										filesMap.put("file", tmpGpxFileName);
										filesMap.put("idx", null);
										files.add(filesMap);
										filesXml.add(tmpGpxFileName);
									//}
								}
							}
						}
					}
					}
					
					String tmpGpxFilePathDir = "";
					String nowFileName = "";
					
					for(int j=0; j<fileItemList.size(); j++){
						item = fileItemList.get(j);
						
						if(!item.isFormField()) {
							String fileName = item.getName();
							System.out.println("FileName : "+fileName);
							if(fileName != null && !"".equals(fileName)){
								Map<String, String> fileMap = files.get(j);
								String tmpGpxFilePathDirFull = String.valueOf(fileMap.get("file"));
								tmpGpxFilePathDir = tmpGpxFilePathDirFull.substring(0, tmpGpxFilePathDirFull.lastIndexOf(File.separator));
								nowFileName = tmpGpxFilePathDirFull.substring(tmpGpxFilePathDirFull.lastIndexOf(File.separator)+1);
								File newLogKeyPath = new File(tmpGpxFilePathDir);
								if(!newLogKeyPath.exists()) newLogKeyPath.mkdir();
								
								System.out.println("nowFileName : "+nowFileName);
								
								if(fileName.indexOf(".gpx") >= 0){
									item.write(new File(tmpGpxFilePathDir + File.separator + nowFileName));
								}
							}
						}
					}
					String saveUserPath = request.getSession().getServletContext().getRealPath("/");
					saveUserPath = saveUserPath.substring(0, saveUserPath.lastIndexOf("GeoCMS_Gateway")) + "GeoCMS"+ 
							saveUserPath.substring(saveUserPath.lastIndexOf("GeoCMS_Gateway")+14) +
							File.separator + "upload"+ File.separator + "GeoTraj";
					String fileName = (String) dataMap.get("fileName");
					String ext = (String) dataMap.get("ext");
					// gps file
					if (fileName != null && fileName.length() > 0) {
						fileName = fileName + "_"+ ext +".gpx";
					}
					// read uploaded file
					DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
					dbf.setIgnoringElementContentWhitespace(true);
					DocumentBuilder db = dbf.newDocumentBuilder();
					Document firstDoc = db.parse(new File(tmpGpxFilePathDir + File.separator + nowFileName));
					NodeList nList1 = firstDoc.getElementsByTagName("trkpt");
					NodeList nList2 = firstDoc.getElementsByTagName("time");
					System.out.println("nList1 : "+ nList1.getLength());
					System.out.println("nList2 : "+ nList2.getLength());
					JSONArray jsonArr = new JSONArray();
					JSONObject jsonObj = new JSONObject();
					String latitude = "0";
					String longitude = "0";
					String updateTraj = "update "+tableName;
					String url = saveUserPath + File.separator + fileName;
					String mpoint = " SET "+colName+" = append("+colName+", 'MPOINT (";
					String gpsdata = "";
					gpsdata += "{\"filePath\" : \"" + tmpGpxFilePathDir + "\", \"gpsData\" : [" ;
					if(nList1 != null && nList1.getLength() > 0){
						for(int j=0; j<nList1.getLength(); j++){
							HashMap<String, String> resultMap = new HashMap<String, String>();
							Element eElement = (Element)nList1.item(j);
							Element eElement2 = (Element)nList2.item(j);
							String time = eElement2.getFirstChild().getNodeValue();
							time = time.replace("T", " ");
							time = time.replace("Z", "");
							SimpleDateFormat transformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
							Date date = transformat.parse(time);
							long timest = date.getTime();
							timest = timest+32400000;
							latitude = eElement.getAttribute("lat");
							longitude = eElement.getAttribute("lon");
							System.out.println("latitude : " + latitude + " longitude : " + longitude);
							JSONObject chJsonObj = new JSONObject();
							chJsonObj.put("lat",latitude);
							chJsonObj.put("lon",longitude);
							
							jsonArr.add(chJsonObj);
							
							resultMap.put("lat",latitude);
							resultMap.put("lon",longitude);
							resultMap.put("seqNum", logKey);
							resultMap.put("projectId", projectId);
							
							if(j == 0)
							{
								param2.put("latitude",latitude);
								param2.put("longitude",longitude);
								param2.put("idx", logKey);
								param2.put("projectId", projectId);
							}
							chJsonObj = new JSONObject();
							chJsonObj.put("lat",latitude);
							chJsonObj.put("lon",longitude);
							jsonArr.add(chJsonObj);
							mpoint += "("+latitude+" "+longitude+") "+timest+", ";
						}
					}
					jsonObj.put("gpsData", jsonArr);
					param2.put("gpsData", jsonObj.toString());
					mpoint = mpoint.substring(0, mpoint.length() - 2);
					mpoint += ")') ";
					
					param2.put("fileName", fileName);
					template.execute(updateTraj + mpoint + whereName);
					int k = pgmDao.updateTraj(param2);
					resultJSON.put("Code", 100);
					resultJSON.put("Message", Message.code100);
				}catch(Exception e){
					resultJSON.put("Code", 600);
					resultJSON.put("Message", Message.code600);
				}
				
				txManager.commit(sts);
			}catch(Exception e){
				e.printStackTrace();
				txManager.rollback(sts);
				resultJSON.put("Code", 800);
				resultJSON.put("Message", Message.code800);
			}
		} catch (Exception e) {
			e.printStackTrace();
			resultJSON.put("Code", 800);
			resultJSON.put("Message", Message.code800);
		}
		
		return callback + "(" + resultJSON.toString() + ")";
	}
	@RequestMapping(value = "/pgm/addPgmSensorLayer/{data}", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String addPgmSensorLayer(@RequestParam("callback") String callback
			, @PathVariable("data") String data
			, Model model, HttpServletRequest request, HttpServletResponse response) {
		response .setHeader("Access-Control-Allow-Methods" , "POST, GET, OPTIONS, DELETE" );
		response.setHeader( "Access-Control-Max-Age" , "3600" );
		response.setHeader( "Access-Control-Allow-Headers" , "x-requested-with" );
		response.setHeader( "Access-Control-Allow-Origin" , "*" );
		
		JSONObject resultJSON = new JSONObject();
		
		try {
			if(data == null || data == "" || data == "null"){
				resultJSON.put("Code", 600);
				resultJSON.put("Message", Message.code600);
			}
			
			DefaultTransactionDefinition def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
			JdbcTemplate template = new JdbcTemplate(dataSource);
			DataSourceTransactionManager txManager = new DataSourceTransactionManager(dataSource);
			TransactionStatus sts = txManager.getTransaction(def);
			
			try{
				List<String> sensorList = new ArrayList<String>();
				sensorList.add("accx");
				sensorList.add("accy");
				sensorList.add("accz");
				sensorList.add("gyrox");
				sensorList.add("gyroy");
				sensorList.add("gyroz");
				
				ObjectMapper m = new ObjectMapper();
				try{
					HashMap<String, Object> dataMap = m.readValue(data, new TypeReference<HashMap<String, Object>>() { });
					
					ArrayList<FileItem> fileItemList = new ArrayList<FileItem>();
					List<Map<String, String>> files = new ArrayList<Map<String, String>>();
					ArrayList<String> filesXml = new ArrayList<String>();
					Map<String, String> param = new HashMap<String, String>();
					Map<String, String> param2 = new HashMap<String, String>();
					Map<String,String> filesMap = new HashMap<String, String>();
					FileItem item = null;
					String logKey = "";
					String projectId = "";
					String tableName = "";
					String colName = "";
					String whereName = "WHERE ";
					if (dataMap != null) {
						Map<String, Object> inputAttrData = (Map<String, Object>) dataMap.get("inputAttrData");
						// insert table
						projectId = (String) dataMap.get("projectId");
						logKey = (String) dataMap.get("logKey");
						
						
						param.put("projectId", projectId);
						tableName = pgmDao.getLayerTableName(param);
						colName = pgmDao.getLayerColName(param);
						String insertSql = "INSERT INTO " + tableName;
						String keySql = " (";
						String valueSql = " (";
						int index = 0;
						// {id=123, name=1234}
						Set<String> keySet = inputAttrData.keySet();
						for (String key : keySet) {
							keySql += key + ",";
							valueSql += "'" + inputAttrData.get(key) + "',";
							
							if(index == 0)
							{
								whereName  += " "+key+" = "+ inputAttrData.get(key);
								index++;
							}
							else
							{
								index++;
							}
							
						}
						
						
						keySql = keySql.substring(0, keySql.length() - 1);
						valueSql = valueSql.substring(0, valueSql.length() - 1);
						
						keySql += ")";
						valueSql += ");";
						
						template.execute(insertSql + keySql + " VALUES " + valueSql);
						
						//파일 정보 저장 변수
						boolean isMultipart = ServletFileUpload.isMultipartContent(request); // 멀티파트인지 체크
						File tempDir = null;
						File uploadDir = null;
						File saveUserPathDir = null;
						
						String fileName = "";
						
						if(isMultipart) {
							String saveUserPath = request.getSession().getServletContext().getRealPath("/");
							saveUserPath = saveUserPath.substring(0, saveUserPath.lastIndexOf("GeoCMS_Gateway")) + "GeoCMS"+ 
									saveUserPath.substring(saveUserPath.lastIndexOf("GeoCMS_Gateway")+14) +
									File.separator + "upload";
							
							saveUserPathDir = new File(saveUserPath);
							if(!saveUserPathDir.exists()) saveUserPathDir.mkdir();
							
							int uploadMaxSize = 2*1024*1024*1024; //1024MB = 1GB
							tempDir = new File(saveUserPath+"/"+"tmp");
							uploadDir = new File(saveUserPath);
							
							if(!tempDir.exists()) tempDir.mkdir();
							if(!uploadDir.exists()) uploadDir.mkdir();
							
							uploadDir = new File(saveUserPath+"/pgmSensor");
							if(!uploadDir.exists()) uploadDir.mkdir();
							
							DiskFileItemFactory factory = new DiskFileItemFactory(uploadMaxSize, tempDir);
							ServletFileUpload upload = new ServletFileUpload(factory);
							
							upload.setSizeMax(uploadMaxSize);
							List items = upload.parseRequest(request);
							Iterator iter = items.iterator();
							
							String changeFileName = "";
							int gpxFileIndex = 1;
							File uploadFile = null;
							String oldSubfix = "";
							File tmpGpxFilePathDir = uploadDir;
							String tmpGpxFilePath = "";
							String tmpGpxFileName = "";
							String prefix = "";
							String suffix = "";
							String tmpPathStr = "";
							String oneSubFix = "";
							HashMap<String, Object> childParam = new HashMap<String, Object>();
							
							while(iter.hasNext()) {
								filesMap = new HashMap<String, String>();
								gpxFileIndex = 1;
								uploadFile = null;
								changeFileName = "";
								tmpGpxFilePath = "";
								tmpGpxFileName = "";
								prefix = "";
								suffix = "";
								oldSubfix = "";
								tmpPathStr = "";
								oneSubFix = "";
								
								item = (FileItem)iter.next();
								if(!item.isFormField()) {
									fileName = item.getName();
									
									//if(fileName.indexOf(".gpx") > 0 || fileName.indexOf(".GPX") > 0) {
									fileItemList.add(item);
									tmpGpxFilePath = tmpGpxFilePathDir + File.separator + fileName;
									//tmpGpxFileName = tmpGpxFilePath.substring(0, tmpGpxFilePath.lastIndexOf("."))+"_mp4.gpx";
									tmpGpxFileName = tmpGpxFilePath.substring(0, tmpGpxFilePath.lastIndexOf("."))+"_json.json";
									prefix = tmpGpxFilePath.substring(0, tmpGpxFilePath.lastIndexOf("."));
									uploadFile  = new File(tmpGpxFilePath);
									
									while((uploadFile = new File(tmpGpxFileName)).exists()) {
										suffix = "_json.json";
										tmpGpxFileName = prefix+"("+gpxFileIndex+")"+suffix;
										gpxFileIndex++;
										uploadFile = new File(tmpGpxFileName);
									}
									
									filesMap.put("file", tmpGpxFileName);
									filesMap.put("idx", null);
									files.add(filesMap);
									filesXml.add(tmpGpxFileName);
									//}
								}
							}
						}
					}
					
					String tmpGpxFilePathDir = "";
					String nowFileName = "";
					
					for(int j=0; j<fileItemList.size(); j++){
						item = fileItemList.get(j);
						
						if(!item.isFormField()) {
							String fileName = item.getName();
							System.out.println("FileName : "+fileName);
							if(fileName != null && !"".equals(fileName)){
								Map<String, String> fileMap = files.get(j);
								String tmpGpxFilePathDirFull = String.valueOf(fileMap.get("file"));
								tmpGpxFilePathDir = tmpGpxFilePathDirFull.substring(0, tmpGpxFilePathDirFull.lastIndexOf(File.separator));
								nowFileName = tmpGpxFilePathDirFull.substring(tmpGpxFilePathDirFull.lastIndexOf(File.separator)+1);
								File newLogKeyPath = new File(tmpGpxFilePathDir);
								if(!newLogKeyPath.exists()) newLogKeyPath.mkdir();
								
								System.out.println("nowFileName : "+nowFileName);
								
								if(fileName.indexOf(".json") >= 0){
									item.write(new File(tmpGpxFilePathDir + File.separator + nowFileName));
								}
							}
						}
					}
					String saveUserPath = request.getSession().getServletContext().getRealPath("/");
					saveUserPath = saveUserPath.substring(0, saveUserPath.lastIndexOf("GeoCMS_Gateway")) + "GeoCMS"+ 
							saveUserPath.substring(saveUserPath.lastIndexOf("GeoCMS_Gateway")+14) +
							File.separator + "upload"+ File.separator + "GeoSensor";
					String fileName = (String) dataMap.get("fileName");
					String ext = (String) dataMap.get("ext");
					// gps file
					if (fileName != null && fileName.length() > 0) {
						fileName = fileName + "_"+ ext +".json";
					}
					// read uploaded file
					JSONParser parser = new JSONParser();
					String updateSensor = "update "+tableName;
					Object obj = parser.parse(new FileReader(tmpGpxFilePathDir + File.separator + nowFileName));
					org.json.simple.JSONObject jsonObject = (org.json.simple.JSONObject) obj;
					Map<String, Object> returnMap = new HashMap<String, Object>();
					returnMap = new ObjectMapper().readValue(jsonObject.toJSONString(), Map.class) ;
					Map<String, Object> map = new HashMap<String, Object>();
					Map<String, Object> newMap = (Map<String, Object>)returnMap.get("temporalGeometries");
					ArrayList<Double> newBbox = (ArrayList<Double>)returnMap.get("bbox");
					Map<String, Object> newMap2 = (Map<String, Object>)newMap.get("acc3d");
					ArrayList<ArrayList<Double>> accMap = (ArrayList<ArrayList<Double>>)newMap2.get("values");
					ArrayList<Long> timeMap = (ArrayList<Long>)newMap2.get("timeline");
					String mdouble = " SET "+colName+" = append("+colName+", 'MDOUBLE(";
					for(int p=0; p<accMap.size(); p++)
					{
						ArrayList<Double> newArray1 = (ArrayList<Double>) accMap.get(p);
						
						//accx
						double accx1 = newArray1.get(0);
						String accx = String.valueOf(accx1);
						long timeLine1 = timeMap.get(p);
						String timeLine = String.valueOf(timeLine1);
						mdouble += accx+" "+timeLine+", ";
					}
					
					double newLonBox = newBbox.get(2);
					double newLatBox = newBbox.get(3);
					String lonBox = String.valueOf(newLonBox);
					String latBox = String.valueOf(newLatBox);
					param2.put("longitude", lonBox);
					param2.put("latitude", latBox);
					param2.put("idx", logKey);
					
					
					mdouble = mdouble.substring(0, mdouble.length() - 2);
					mdouble += ")')";
					
					template.execute(updateSensor + mdouble + whereName);
					int k = pgmDao.updateSensor(param2);
					resultJSON.put("Code", 100);
					resultJSON.put("Message", Message.code100);
				}catch(Exception e){
					resultJSON.put("Code", 600);
					resultJSON.put("Message", Message.code600);
				}
				
				txManager.commit(sts);
			}catch(Exception e){
				e.printStackTrace();
				txManager.rollback(sts);
				resultJSON.put("Code", 800);
				resultJSON.put("Message", Message.code800);
			}
		} catch (Exception e) {
			e.printStackTrace();
			resultJSON.put("Code", 800);
			resultJSON.put("Message", Message.code800);
		}
		
		return callback + "(" + resultJSON.toString() + ")";
	}
	
	
	@RequestMapping(value = "/pgm/addPgmImageLayer/{data}/{viewArr}/{viewTag}", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String addPgmImageLayer(@RequestParam("callback") String callback
			, @PathVariable("data") String data
			, @PathVariable("viewArr") String viewArr
			, @PathVariable("viewTag") String viewTag
			, Model model, HttpServletRequest request, HttpServletResponse response) {
		response .setHeader("Access-Control-Allow-Methods" , "POST, GET, OPTIONS, DELETE" );
		response.setHeader( "Access-Control-Max-Age" , "3600" );
		response.setHeader( "Access-Control-Allow-Headers" , "x-requested-with" );
		response.setHeader( "Access-Control-Allow-Origin" , "*" );
		
		JSONObject resultJSON = new JSONObject();
		
		File changeFile = null; 
		String tmpPrefixa = "";
		String tmpLastfixa = "";
		String tmpPreThumb = "";
		BufferedImage sourceImage = null;
		FileOutputStream fs = null;
		
		try {
			if(data == null || data == "" || data == "null"){
				resultJSON.put("Code", 600);
				resultJSON.put("Message", Message.code600);
			}
			
			DefaultTransactionDefinition def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
			JdbcTemplate template = new JdbcTemplate(dataSource);
			DataSourceTransactionManager txManager = new DataSourceTransactionManager(dataSource);
			TransactionStatus sts = txManager.getTransaction(def);
			
			try{
				List<String> sensorList = new ArrayList<String>();
				sensorList.add("accx");
				sensorList.add("accy");
				sensorList.add("accz");
				sensorList.add("gyrox");
				sensorList.add("gyroy");
				sensorList.add("gyroz");
				
				ObjectMapper m = new ObjectMapper();
				try{
					HashMap<String, Object> dataMap = m.readValue(data, new TypeReference<HashMap<String, Object>>() { });
					
					ArrayList<FileItem> fileItemList = new ArrayList<FileItem>();
					List<Map<String, String>> files = new ArrayList<Map<String, String>>();
					ArrayList<String> filesXml = new ArrayList<String>();
					
					Map<String,String> filesMap = new HashMap<String, String>();
					FileItem item = null;
					String tableName = "";
					String colName = "";
					String whereName = "";
					if (dataMap != null) {
						Map<String, Object> inputAttrData = (Map<String, Object>) dataMap.get("inputAttrData");
						
						// insert table
						String projectId = (String) dataMap.get("projectId");
						
						Map<String, String> param = new HashMap<String, String>();
						param.put("projectId", projectId);
						tableName = pgmDao.getLayerTableName(param);
						colName = pgmDao.getLayerColName(param);
						String insertSql = "INSERT INTO " + tableName;
						String keySql = " (";
						String valueSql = " (";
						
						// {id=123, name=1234}
						Set<String> keySet = inputAttrData.keySet();
						for (String key : keySet) {
							keySql += key + ",";
							valueSql += "'" + inputAttrData.get(key) + "',";
							if(key == "id")
							{
								whereName  = " WHERE "+key+" = "+ inputAttrData.get(key);
							}
						}
						
						
						keySql = keySql.substring(0, keySql.length() - 1);
						valueSql = valueSql.substring(0, valueSql.length() - 1);
						
						keySql += ")";
						valueSql += ");";
						
						template.execute(insertSql + keySql + " VALUES " + valueSql);
						
						//파일 정보 저장 변수
					}
					
					String tmpGpxFilePathDir = "";
					String nowFileName = "";
					
					String saveUserPath = request.getSession().getServletContext().getRealPath("/");
					saveUserPath = saveUserPath.substring(0, saveUserPath.lastIndexOf("GeoCMS_Gateway")) + "GeoCMS"+ 
							saveUserPath.substring(saveUserPath.lastIndexOf("GeoCMS_Gateway")+14) +
							File.separator + "upload"+ File.separator + "GeoPhoto";
					String fileName = (String) dataMap.get("fileName");
					// gps file
					String savefullStr = saveUserPath + "/" +viewArr+"."+viewTag;
					// read uploaded file
					
					
					changeFile = new File(savefullStr);
					tmpPrefixa = savefullStr.substring(0, savefullStr.lastIndexOf("."));
					tmpLastfixa = savefullStr.substring(savefullStr.lastIndexOf(".")+1);
					
					fs = new FileOutputStream(new File(tmpPrefixa + "_BASE_thumbnail."+viewTag));
					
					//좌표 가져오기
					
					//파일 이름 가져오기
					
					String latitude = "0";
					String longitude = "0";
					String updateVideo = "update "+tableName;
					String url = tmpPrefixa +"_thumbnail_600.jpg";
					String stphoto = " SET "+colName+" = append("+colName+", 'STPHOTO ("+ url + " 600 442 (-1 -1 -1 -1 -1) null ";
					String mframe = "";
					
					stphoto += "("+longitude+" "+latitude+") 1000)')";
					
					template.execute(updateVideo + stphoto + whereName);
					resultJSON.put("Code", 100);
					resultJSON.put("Message", Message.code100);
				}catch(Exception e){
					resultJSON.put("Code", 600);
					resultJSON.put("Message", Message.code600);
				}
				
				txManager.commit(sts);
			}catch(Exception e){
				e.printStackTrace();
				txManager.rollback(sts);
				resultJSON.put("Code", 800);
				resultJSON.put("Message", Message.code800);
			}
		} catch (Exception e) {
			e.printStackTrace();
			resultJSON.put("Code", 800);
			resultJSON.put("Message", Message.code800);
		}
		
		return callback + "(" + resultJSON.toString() + ")";
	}
	
	
	@RequestMapping(value = "/pgm/getProjectRowContent/{token}/{loginId}/{type}/{projectIdx}/{rowNum}/{contentNum}", method = RequestMethod.GET, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String getProjectService(@RequestParam("callback") String callback
			, @PathVariable("token") String token
			, @PathVariable("loginId") String loginId
			, @PathVariable("projectIdx") String projectIdx
			, @PathVariable("type") String type
			, @PathVariable("rowNum") String rowNum
			, @PathVariable("contentNum") String contentNum
			, Model model, HttpServletRequest request) {
		JSONObject resultJSON = new JSONObject();
		
		Map<String, String> param = new HashMap<String, String>();
		param.put("token", token);
		param.put("projectIdx", projectIdx);
		param.put("rowNum", rowNum);
		param.put("loginId", loginId);
		param.put("getProject", "Y");
		param.put("type", type);
		try {
			
			List<Map<String, String>> resultList = pgmDao.selectProjectRowList(param);
			resultJSON.put("Code", 100);
			resultJSON.put("Message", Message.code100);
			resultJSON.put("Data", JSONArray.fromObject(resultList));
		} catch (Exception e) {
			e.printStackTrace();
			resultJSON.put("Code", 800);
			resultJSON.put("Message", Message.code800);
		}
		
		return callback + "(" + resultJSON.toString() + ")";
	}
	
	@RequestMapping(value = "/pgm/selectAllLayer/{token}/{loginId}", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String selectAllLayer(@PathVariable("callback") String callback
			,@RequestParam("token") String token
			, @PathVariable("loginId") String loginId
			, Model model, HttpServletRequest request, HttpServletResponse response) {
		JSONObject resultJSON = new JSONObject();
		List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();
		
		try {
			//get Base
			resultList = pgmDao.selectAllLayer(); // attr, type
			if(resultList != null && resultList.size()>0) {
				resultJSON.put("Code", 100);
				resultJSON.put("Message", Message.code100);
				resultJSON.put("Data", resultList);
			}else {
				resultJSON.put("Code", 200);
				resultJSON.put("Message", Message.code200);
			}
		} catch (Exception e) {
			e.printStackTrace();
			resultJSON.put("Code", 800);
			resultJSON.put("Message", Message.code800);
		}
		
		return callback + "(" + resultJSON.toString() + ")";
	}
	
	
	@RequestMapping(value = "/pgm/addTrajLayer/{data}/{viewArr}/{viewTag}", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String addTrajLayer(@RequestParam("callback") String callback
			, @PathVariable("data") String data
			, @PathVariable("viewArr") String viewArr
			, @PathVariable("viewTag") String viewTag
			, Model model, HttpServletRequest request, HttpServletResponse response) {
		response .setHeader("Access-Control-Allow-Methods" , "POST, GET, OPTIONS, DELETE" );
		response.setHeader( "Access-Control-Max-Age" , "3600" );
		response.setHeader( "Access-Control-Allow-Headers" , "x-requested-with" );
		response.setHeader( "Access-Control-Allow-Origin" , "*" );
		
		JSONObject resultJSON = new JSONObject();
		
		File changeFile = null; 
		String tmpPrefixa = "";
		String tmpLastfixa = "";
		String tmpPreThumb = "";
		BufferedImage sourceImage = null;
		FileOutputStream fs = null;
		
		try {
			if(data == null || data == "" || data == "null"){
				resultJSON.put("Code", 600);
				resultJSON.put("Message", Message.code600);
			}
			
			DefaultTransactionDefinition def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
			JdbcTemplate template = new JdbcTemplate(dataSource);
			DataSourceTransactionManager txManager = new DataSourceTransactionManager(dataSource);
			TransactionStatus sts = txManager.getTransaction(def);
			
			try{
				List<String> sensorList = new ArrayList<String>();
				sensorList.add("accx");
				sensorList.add("accy");
				sensorList.add("accz");
				sensorList.add("gyrox");
				sensorList.add("gyroy");
				sensorList.add("gyroz");
				
				ObjectMapper m = new ObjectMapper();
				try{
					HashMap<String, Object> dataMap = m.readValue(data, new TypeReference<HashMap<String, Object>>() { });
					
					ArrayList<FileItem> fileItemList = new ArrayList<FileItem>();
					List<Map<String, String>> files = new ArrayList<Map<String, String>>();
					ArrayList<String> filesXml = new ArrayList<String>();
					
					Map<String,String> filesMap = new HashMap<String, String>();
					FileItem item = null;
					String tableName = "";
					String whereName = "";
					if (dataMap != null) {
						Map<String, Object> inputAttrData = (Map<String, Object>) dataMap.get("inputAttrData");
						
						// insert table
						String projectId = (String) dataMap.get("projectId");
						
						Map<String, String> param = new HashMap<String, String>();
						param.put("projectId", projectId);
						tableName = pgmDao.getLayerTableName(param);
						String insertSql = "INSERT INTO " + tableName;
						String keySql = " (";
						String valueSql = " (";
						
						// {id=123, name=1234}
						Set<String> keySet = inputAttrData.keySet();
						for (String key : keySet) {
							keySql += key + ",";
							valueSql += "'" + inputAttrData.get(key) + "',";
							if(key == "id")
							{
								whereName  = " WHERE "+key+" = "+ inputAttrData.get(key);
							}
						}
						
						
						keySql = keySql.substring(0, keySql.length() - 1);
						valueSql = valueSql.substring(0, valueSql.length() - 1);
						
						keySql += ")";
						valueSql += ");";
						
						template.execute(insertSql + keySql + " VALUES " + valueSql);
						
						//파일 정보 저장 변수
					}
					
					String tmpGpxFilePathDir = "";
					String nowFileName = "";
					
					String saveUserPath = request.getSession().getServletContext().getRealPath("/");
					saveUserPath = saveUserPath.substring(0, saveUserPath.lastIndexOf("GeoCMS_Gateway")) + "GeoCMS"+ 
							saveUserPath.substring(saveUserPath.lastIndexOf("GeoCMS_Gateway")+14) +
							File.separator + "upload"+ File.separator + "GeoPhoto";
					String fileName = (String) dataMap.get("fileName");
					// gps file
					String savefullStr = saveUserPath + "/" +viewArr+"."+viewTag;
					// read uploaded file
					
					
					changeFile = new File(savefullStr);
					tmpPrefixa = savefullStr.substring(0, savefullStr.lastIndexOf("."));
					tmpLastfixa = savefullStr.substring(savefullStr.lastIndexOf(".")+1);
					
					fs = new FileOutputStream(new File(tmpPrefixa + "_BASE_thumbnail."+viewTag));
					
					//좌표 가져오기
					
					//파일 이름 가져오기
					
					String latitude = "0";
					String longitude = "0";
					String updateVideo = "update "+tableName;
					String url = tmpPrefixa +"_thumbnail_600.jpg";
					String stphoto = " SET st = append(st, 'STPHOTO ("+ url + " 600 442 (-1 -1 -1 -1 -1) null ";
					String mframe = "";
					
					stphoto += "("+longitude+" "+latitude+") 1000)')";
					
					template.execute(updateVideo + stphoto + whereName);
					resultJSON.put("Code", 100);
					resultJSON.put("Message", Message.code100);
				}catch(Exception e){
					resultJSON.put("Code", 600);
					resultJSON.put("Message", Message.code600);
				}
				
				txManager.commit(sts);
			}catch(Exception e){
				e.printStackTrace();
				txManager.rollback(sts);
				resultJSON.put("Code", 800);
				resultJSON.put("Message", Message.code800);
			}
		} catch (Exception e) {
			e.printStackTrace();
			resultJSON.put("Code", 800);
			resultJSON.put("Message", Message.code800);
		}
		
		return callback + "(" + resultJSON.toString() + ")";
	}
	
	
	@RequestMapping(value = "/pgm/insertAnalysisQuery/{token}/{loginId}/{type}/{projectIdx}/{rowNum}/{contentNum}", method = RequestMethod.GET, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String insertAnalysisQuery(@RequestParam("callback") String callback
			, @PathVariable("token") String token
			, @PathVariable("loginId") String loginId
			, @PathVariable("projectIdx") String projectIdx
			, @PathVariable("type") String type
			, @PathVariable("rowNum") String rowNum
			, @PathVariable("contentNum") String contentNum
			, Model model, HttpServletRequest request) {
		JSONObject resultJSON = new JSONObject();
		
		Map<String, String> param = new HashMap<String, String>();
		param.put("token", token);
		param.put("projectIdx", projectIdx);
		param.put("rowNum", rowNum);
		param.put("loginId", loginId);
		param.put("getProject", "Y");
		param.put("type", type);
		try {
			
			List<Map<String, String>> resultList = pgmDao.selectProjectRowList(param);
			resultJSON.put("Code", 100);
			resultJSON.put("Message", Message.code100);
			resultJSON.put("Data", JSONArray.fromObject(resultList));
		} catch (Exception e) {
			e.printStackTrace();
			resultJSON.put("Code", 800);
			resultJSON.put("Message", Message.code800);
		}
		
		return callback + "(" + resultJSON.toString() + ")";
	}
	
	public String dataReplaceFun(String oneData) {
		String replaceResultData = "";
		
		if(oneData != null){
			replaceResultData = oneData.replaceAll("&sbsp","/");
			replaceResultData = replaceResultData.replaceAll("&nbsp", "");
			replaceResultData = replaceResultData.replaceAll("&mbsp","?");
			replaceResultData = replaceResultData.replaceAll("&pbsp","#");
			replaceResultData = replaceResultData.replaceAll("&obsp",".");
			replaceResultData = replaceResultData.replaceAll("&lt","<");
			replaceResultData = replaceResultData.replaceAll("&gt",">");
			replaceResultData = replaceResultData.replaceAll("&bt","\\\\");
			replaceResultData = replaceResultData.replaceAll("&mt","%");
			replaceResultData = replaceResultData.replaceAll("&vbsp",";");
			replaceResultData = replaceResultData.replaceAll("&rnsp","\r");
			replaceResultData = replaceResultData.replaceAll("&nnsp","\n");
			replaceResultData = replaceResultData.replaceAll("&xbsp",",");
		}
		
		return replaceResultData;
	}
}