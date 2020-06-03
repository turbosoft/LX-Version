package kr.co.turbosoft.geocms.controller;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.lang.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import kr.co.turbosoft.geocms.util.XMLRW;

@Controller
public class XMLController {
	
	@RequestMapping(value = "/geoXml.do", method = RequestMethod.POST)
	public void geoXml(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		request.setCharacterEncoding("utf-8");
		System.out.println("GeoCMS req file name : " + request.getParameter("file_name"));
		String type = request.getParameter("type");
		String[] buf = request.getParameter("file_name").split("\\/");
		String upload_type = buf[0];
		String file_name = buf[1];
		String xml_data = request.getParameter("xml_data");
		String file_encode = "";
		if(file_name != null && !"".equals(file_name)){
//			file_name = file_name.substring(0, file_name.lastIndexOf(".")) + ".xml";
			file_encode = URLEncoder.encode(file_name,"utf-8");
		}
		/* ecliplse */
//		String fileSavePathStr = request.getSession().getServletContext().getRealPath("/");
//		fileSavePathStr = fileSavePathStr.substring(0,fileSavePathStr.length()-1)+"_Gateway/upload";
		
		/*tomcat*/
//		String fileSavePathStr = request.getSession().getServletContext().getRealPath("/");
//		fileSavePathStr = fileSavePathStr.substring(0, fileSavePathStr.indexOf(File.separator+"webapps"));
//		fileSavePathStr = fileSavePathStr + File.separator+"webapps" + File.separator + "GeoCMS_Gateway/upload";
		
		String serverTypeStr = request.getParameter("serverType");
		String serverUrlSrt = request.getParameter("serverUrl");
		String serverViewPortStr = request.getParameter("serverViewPort");
		String serverPathStr = request.getParameter("serverPath");
		String serverPortStr = request.getParameter("serverPort");
		String serverIdStr = request.getParameter("serverId");
		String serverPassStr = request.getParameter("serverPass");
		
		String file_dir = "";
		if(serverTypeStr != null && "URL".equals(serverTypeStr)){
			file_dir = "http://"+ serverUrlSrt +":"+ serverViewPortStr +"/shares/"+serverPathStr +"/"+ upload_type +"/"+file_encode;
		}
		
		String fileSavePathStr = request.getSession().getServletContext().getRealPath("/");
		fileSavePathStr = fileSavePathStr.substring(0,fileSavePathStr.length()-1) + File.separator + serverPathStr;
		
		File upDir = new File(fileSavePathStr);
		if(!upDir.exists()){
			upDir.mkdir();
		}
		System.out.println(xml_data);
		
		String result = "";
		XMLRW xmlRW = new XMLRW();
		xmlRW.geoXmlRWCon(fileSavePathStr, serverUrlSrt, serverIdStr, serverPassStr, serverPortStr, serverPathStr);
		
		if(type != null){
			if("load".equals(type)){
				result = xmlRW.getXmlData(file_dir, file_name, upload_type);
			}else if("save".equals(type)){
				result = xmlRW.write(file_dir, file_name, xml_data, upload_type);
			}
		}
		System.out.println(result);
		//setContentType �� ���� �����ϰ� getWriter		
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.print(result);
	}

	private String getFileName(final Part part) {

		for (String content : part.getHeader("content-disposition").split(";")) {
			if (content.trim().startsWith("filename")) {
				return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
			}
		}
		return null;
	}
	
	// location to store file uploaded
	private static final String TEMP_DIRECTORY = "temp";
	private static final String UPLOAD_DIRECTORY = "upload";
	// upload settings
	private static final int MEMORY_THRESHOLD   = 1024 * 1024 * 3;  // 3MB
	private static final int MAX_FILE_SIZE      = 1024 * 1024 * 40; // 40MB
	private static final int MAX_REQUEST_SIZE   = 1024 * 1024 * 50; // 50MB
	
	private static final int SCREEN_WIDTH		= 760;
	private static final int SCREEN_HEIGHT		= 460;
	
	
	@RequestMapping(value = "/geoVideoImportUrbanAI.do", method = RequestMethod.POST)
	public void geoVideoImportUrbanAI(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		System.out.println("GeoCMS :: geoVideoImportUrbanAI");

		request.setCharacterEncoding("utf-8");
		response.setContentType("text/xml;charset=utf-8");
		
//		String idx = request.getParameter("idx");
		String file_url = request.getParameter("file_url");
		String file_name = file_url;

//		if (!(idx != null && idx.length() > 0 && file_url != null && file_url.length() > 0)) {
		if (!(file_url != null && file_url.length() > 0)) {
			return;
		}
		int lindex = file_url.lastIndexOf(".");
		if (lindex > 0) {
			file_name = file_url.substring(0, lindex) + ".xml";
		}

		JSONParser parser = new JSONParser();
		StringWriter writer = new StringWriter();

		String fileSavePathStr = request.getSession().getServletContext().getRealPath("/");
		fileSavePathStr = fileSavePathStr.substring(0,fileSavePathStr.length()-1) + File.separator + UPLOAD_DIRECTORY;

		boolean bXml = false;
		XMLRW xmlRW = new XMLRW();
		xmlRW.geoXmlRWCon(fileSavePathStr, null, null, null, null, "upload");
		String strXml = xmlRW.getXmlData(null, file_name, "GeoVideo");
		if (strXml != null && strXml.length() > 0) {
			strXml = strXml.trim();
			if (strXml.startsWith("<?xml") && strXml.endsWith("</GeoCMS>")) {
				bXml = true;
			}
		}
		
		if (bXml) {
			int nIdx = strXml.lastIndexOf("</GeoCMS>");
			if (nIdx > 0) {
				writer.write(strXml.substring(0, nIdx));
			}
		}
		else {
			writer.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
			writer.write("<GeoCMS>\n");
		}
		
		try
		{
			DiskFileItemFactory factory = new DiskFileItemFactory();
			factory.setSizeThreshold(MEMORY_THRESHOLD);
			factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
			
			ServletFileUpload upload = new ServletFileUpload(factory);
			upload.setFileSizeMax(MAX_FILE_SIZE);
			upload.setSizeMax(MAX_REQUEST_SIZE);
			String uploadPath = request.getSession().getServletContext().getRealPath("") + File.separator + TEMP_DIRECTORY;

			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists()) {
				uploadDir.mkdir();
			}
			
			List<FileItem> fileItems = upload.parseRequest(request);
			if (fileItems != null && fileItems.size() > 0) {
				for (FileItem item : fileItems) {
					if (!item.isFormField()) {

						String fileName = new File(item.getName()).getName();
						InputStream jsonfile = item.getInputStream();
						Reader reader = new InputStreamReader(jsonfile);
						JSONObject jsonObject = (JSONObject)parser.parse(reader);
						JSONArray features = (JSONArray) jsonObject.get("features");
						if (features != null) {
							Iterator<JSONObject> itFeatures = features.iterator();
							while(itFeatures.hasNext()) {
								JSONObject feature = itFeatures.next();
								if (feature != null) {
									System.out.println("==> Feature");
									
									// obj type 2(g)
									String xgsId = "g"; // geometry
									Long xglTop = 0L;
									Long xglLeft = 0L;
									List<Long> xgaXstr = new ArrayList<Long>();
									List<Long> xgaYstr = new ArrayList<Long>();
									String xgsLinecolor = "#FF0000"; // 기본값
									String xgsBackgroundcolor = "#FF0000"; // 기본값
									String xgsType = "";
									Long xglFrameline = 75L; // 모르겠음. 기본값.
									Long xglFramestart = 0L; // UrbanAI 값 * 5 / 1000
									Long xglFrameend = 0L; // UrbanAI 값 * 5 / 1000

									
									String sType = (String) feature.get("type");
									System.out.println("type : " + sType);
									String sCategory = (String) feature.get("category");
									System.out.println("category : " + sCategory);
									Double dWeights = (Double) feature.get("weights");
									System.out.println("weights : " + dWeights);

									JSONObject objGeometry = (JSONObject) feature.get("geometry");
									if (objGeometry != null) {
										System.out.print("  ");
										System.out.println("==> geometry");

										String sgType = (String) objGeometry.get("type");
										System.out.print("  ");
										System.out.println("type : " + sgType);
										JSONArray coordinates = (JSONArray) objGeometry.get("coordinates");
										if (coordinates != null && coordinates.size() >= 2) {
											Double c1 = (Double) coordinates.get(0);
											Double c2 = (Double) coordinates.get(1);
											System.out.print("  ");
											System.out.println("coordinates : " + c1 + " , " + c2);
										}
									}
									
									JSONObject objProperties = (JSONObject) feature.get("properties");
									if (objProperties != null) {
										System.out.print("  ");
										System.out.println("==> properties");

										Long sId = (Long) objProperties.get("id");
										System.out.print("  ");
										System.out.println("id : " + sId);
										String sAnnotationText = (String) objProperties.get("annotationText");
										System.out.print("  ");
										System.out.println("annotationText : " + sAnnotationText);
										String sUri = (String) objProperties.get("uri");
										System.out.print("  ");
										System.out.println("uri : " + sUri);
										String sWidth = (String) objProperties.get("width");
										System.out.print("  ");
										System.out.println("width : " + sWidth);
										String sHeight = (String) objProperties.get("height");
										System.out.print("  ");
										System.out.println("height : " + sHeight);

										long lWidth = Long.parseLong(sWidth);
										long lHeight = Long.parseLong(sHeight);
										
										JSONObject objAreaInImageJSON = (JSONObject) objProperties.get("areaInImageJSON");
										if (objAreaInImageJSON != null) {
											System.out.print("    ");
											System.out.println("==> areaInImageJSON");

											String saType = (String) objAreaInImageJSON.get("type");
											System.out.print("    ");
											System.out.println("type : " + saType);

											// for xml
											Long lXMin = Long.MAX_VALUE;
											Long lYMin = Long.MAX_VALUE;

											JSONArray coordinates = (JSONArray) objAreaInImageJSON.get("coordinates");
											if (coordinates != null) {
												Iterator<JSONArray> itCoordinates = coordinates.iterator();
												while(itCoordinates.hasNext()) {
													JSONArray arCood = itCoordinates.next();
													if (arCood != null && arCood.size() >= 2) {
														Long c1 = (Long) arCood.get(0);
														Long c2 = (Long) arCood.get(1);
														System.out.print("    ");
														System.out.println("coordinates : " + c1 + " , " + c2);
														
														// W:H = w:h
														// Wh = Hw
														// h = Hw/W
														long c11 = SCREEN_WIDTH * c1 / lWidth;
														long c22 = SCREEN_HEIGHT * c2 / lHeight;
														
														// for xml
														xgaXstr.add(c11);
														xgaYstr.add(c22);
														if (c11 < lXMin) lXMin = c11;
														if (c22 < lYMin) lYMin = c22;
													}
												}
											}
											
											// for xml
											xglTop = lYMin != Long.MAX_VALUE ? lYMin : 0L;
											xglLeft = lXMin != Long.MAX_VALUE ? lXMin : 0L;

											// for xml
											if ("Polygon".equalsIgnoreCase(saType)) {
												xgsType = "point";
											}
											else {
												continue;
											}
										}

										JSONObject objAnnotationJSON = (JSONObject) objProperties.get("annotationJSON");
										if (objAnnotationJSON != null) {
											System.out.print("    ");
											System.out.println("==> annotationJSON");

											String sModel = (String) objAnnotationJSON.get("model");
											System.out.print("    ");
											System.out.println("model : " + sModel);
											String sClassId = (String) objAnnotationJSON.get("classId");
											System.out.print("    ");
											System.out.println("classId : " + sClassId);
											String sClassName = (String) objAnnotationJSON.get("className");
											System.out.print("    ");
											System.out.println("className : " + sClassName);
										}

										JSONArray period = (JSONArray) objProperties.get("period");
										if (period != null && period.size() >= 2) {
											Long c1 = (Long) period.get(0);
											Long c2 = (Long) period.get(1);
											System.out.print("    ");
											System.out.println("period : " + c1 + " , " + c2);
											
											// xml
											xglFramestart = c1 * 5 / 1000;
											xglFrameend = c2 * 5 / 1000;
										}
									}
									System.out.println("");
									
									// write to xml
									writer.write("<obj>\n");

									// write to xml
									writer.write("<id>" + xgsId + "</id>\n");
									writer.write("<top>" + xglTop + "</top>\n");
									writer.write("<left>" + xglLeft + "</left>\n");
									writer.write("<xstr>" + StringUtils.join(xgaXstr, "_") + "</xstr>\n");
									writer.write("<ystr>" + StringUtils.join(xgaYstr, "_") + "</ystr>\n");
									writer.write("<linecolor>" + xgsLinecolor + "</linecolor>\n");
									writer.write("<backgroundcolor>" + xgsBackgroundcolor + "</backgroundcolor>\n");
									writer.write("<type>" + xgsType + "</type>\n");
									writer.write("<frameline>" + xglFrameline + "</frameline>\n");
									writer.write("<framestart>" + xglFramestart + "</framestart>\n");
									writer.write("<frameend>" + xglFrameend + "</frameend>\n");
									
									// write to xml
									writer.write("</obj>\n");
								}
							}
						}
					}
				}
			}
		}
		catch (Exception e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		writer.write("</GeoCMS>\n");
		System.out.println("");
		System.out.print(writer.toString());

		String xmlResult = xmlRW.write(null, file_name, writer.toString(), "GeoVideo");
		if ("XML_SAVE_SUCCESS".equalsIgnoreCase(xmlResult)) {
			response.getWriter().write(writer.toString());
		}
	}

	@RequestMapping(value = "/geoImageImportVgg.do", method = RequestMethod.POST)
	public void geoImageImportVgg(HttpServletRequest request, HttpServletResponse response) throws IOException {

		System.out.println("GeoCMS :: geoImageImportVgg");

		request.setCharacterEncoding("utf-8");
		response.setContentType("text/xml;charset=utf-8");
		
		String file_url = request.getParameter("file_url");
		String file_name = file_url;

		if (!(file_url != null && file_url.length() > 0)) {
			return;
		}
		int lindex = file_url.lastIndexOf(".");
		if (lindex > 0) {
			file_name = file_url.substring(0, lindex) + ".xml";
		}

		JSONParser parser = new JSONParser();
		StringWriter writer = new StringWriter();

		String fileSavePathStr = request.getSession().getServletContext().getRealPath("/");
		fileSavePathStr = fileSavePathStr.substring(0,fileSavePathStr.length()-1) + File.separator + UPLOAD_DIRECTORY;

		boolean bXml = false;
		XMLRW xmlRW = new XMLRW();
		xmlRW.geoXmlRWCon(fileSavePathStr, null, null, null, null, "upload");
		String strXml = xmlRW.getXmlData(null, file_name, "GeoPhoto");
		if (strXml != null && strXml.length() > 0) {
			strXml = strXml.trim();
			if (strXml.startsWith("<?xml") && strXml.endsWith("</GeoCMS>")) {
				bXml = true;
			}
		}
		
		if (bXml) {
			int nIdx = strXml.lastIndexOf("</GeoCMS>");
			if (nIdx > 0) {
				writer.write(strXml.substring(0, nIdx));
			}
		}
		else {
			writer.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
			writer.write("<GeoCMS>\n");
		}
		
		try
		{
			DiskFileItemFactory factory = new DiskFileItemFactory();
			factory.setSizeThreshold(MEMORY_THRESHOLD);
			factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
			
			ServletFileUpload upload = new ServletFileUpload(factory);
			upload.setFileSizeMax(MAX_FILE_SIZE);
			upload.setSizeMax(MAX_REQUEST_SIZE);
			String uploadPath = request.getSession().getServletContext().getRealPath("") + File.separator + TEMP_DIRECTORY;

			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists()) {
				uploadDir.mkdir();
			}
			
			List<FileItem> fileItems = upload.parseRequest(request);
			if (fileItems != null && fileItems.size() > 0) {
				for (FileItem item : fileItems) {
					if (!item.isFormField()) {

						String fileName = new File(item.getName()).getName();
						InputStream jsonfile = item.getInputStream();
						Reader reader = new InputStreamReader(jsonfile);
						JSONObject jsonObject = (JSONObject)parser.parse(reader);

						Set<String> setKey = jsonObject.keySet();
						Iterator<String> itKey = setKey.iterator();
						while (itKey.hasNext()) {
							String key = itKey.next();
							System.out.println("key: " + key);

							JSONObject objData = (JSONObject) jsonObject.get(key);
							if (objData != null) {
								JSONArray regions = (JSONArray) objData.get("regions");
								if (regions != null) {
									Iterator<JSONObject> itRegions = regions.iterator();
									while(itRegions.hasNext()) {
										JSONObject objRegion = (JSONObject)itRegions.next();
										if (objRegion != null) {
											JSONObject objShape = (JSONObject) objRegion.get("shape_attributes");
											if (objShape != null) {

												// obj type 2(g)
												String xgsId = "g"; // geometry
												Long xglTop = 0L;
												Long xglLeft = 0L;
												List<Long> xgaXstr = new ArrayList<Long>();
												List<Long> xgaYstr = new ArrayList<Long>();
												String xgsLinecolor = "#FF0000"; // 기본값
												String xgsBackgroundcolor = "#FF0000"; // 기본값
												String xgsType = "";
												Long xglFrameline = 75L; // 모르겠음. 기본값.
												Long xglFramestart = 0L; // UrbanAI 값 * 5 / 1000
												Long xglFrameend = 0L; // UrbanAI 값 * 5 / 1000

												Long lXMin = Long.MAX_VALUE;
												Long lYMin = Long.MAX_VALUE;

												String name = (String) objShape.get("name");
												System.out.println("name: " + name);

												// for xml
												if ("Polygon".equalsIgnoreCase(name)) {
													xgsType = "point";
												}
												else {
													continue;
												}
												
												JSONArray all_points_x = (JSONArray) objShape.get("all_points_x");
												JSONArray all_points_y = (JSONArray) objShape.get("all_points_y");
												if (all_points_x != null && all_points_y != null) {
													Iterator<Double> itx = all_points_x.iterator();
													Iterator<Double> ity = all_points_y.iterator();
													while(itx.hasNext() && ity.hasNext()) {
														Double x = itx.next();
														Double y = ity.next();
														
														long c11 = x.longValue();
														long c22 = y.longValue();

														xgaXstr.add(c11);
														xgaYstr.add(c22);
														if (c11 < lXMin) lXMin = c11;
														if (c22 < lYMin) lYMin = c22;

													} // end while -- iterator
												}// end if -- all_points_xy
												
												// for xml
												xglTop = lYMin != Long.MAX_VALUE ? lYMin : 0L;
												xglLeft = lXMin != Long.MAX_VALUE ? lXMin : 0L;

												// write to xml
												writer.write("<obj>\n");

												// write to xml
												writer.write("<id>" + xgsId + "</id>\n");
												writer.write("<top>" + xglTop + "</top>\n");
												writer.write("<left>" + xglLeft + "</left>\n");
												writer.write("<xstr>" + StringUtils.join(xgaXstr, "_") + "</xstr>\n");
												writer.write("<ystr>" + StringUtils.join(xgaYstr, "_") + "</ystr>\n");
												writer.write("<linecolor>" + xgsLinecolor + "</linecolor>\n");
												writer.write("<backgroundcolor>" + xgsBackgroundcolor + "</backgroundcolor>\n");
												writer.write("<type>" + xgsType + "</type>\n");
												writer.write("<frameline>" + xglFrameline + "</frameline>\n");
												writer.write("<framestart>" + xglFramestart + "</framestart>\n");
												writer.write("<frameend>" + xglFrameend + "</frameend>\n");
												
												// write to xml
												writer.write("</obj>\n");
												
											} // end if - objShape
										} // end if - objRegion
									} // end while - regions
								} // end if - regions
							} // end if - objData
						} // end while - key
					}
				}
			}
		}
		catch (Exception e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		writer.write("</GeoCMS>\n");
		System.out.println("");
		System.out.print(writer.toString());

		String xmlResult = xmlRW.write(null, file_name, writer.toString(), "GeoPhoto");
		if ("XML_SAVE_SUCCESS".equalsIgnoreCase(xmlResult)) {
			response.getWriter().write(writer.toString());
		}
	}
	
	@RequestMapping(value = "/geoImageExportVgg.do")
	public void geoImageExportVgg(HttpServletRequest request, HttpServletResponse response) throws IOException {

		request.setCharacterEncoding("utf-8");
		System.out.println("geoImageExportVgg req file name : " + request.getParameter("file_name"));

		String upload_type = null;
		String file_name = null;
		
		String kind = request.getParameter("kind");
		String[] buf = request.getParameter("file_name").split("\\/");
		if (buf != null && buf.length >= 1) {
			upload_type = buf[0];
			file_name = buf[1];
		}
		String serverPathStr = "upload";
		String fileSavePathStr = request.getSession().getServletContext().getRealPath("/");
		fileSavePathStr = fileSavePathStr.substring(0,fileSavePathStr.length()-1) + File.separator + UPLOAD_DIRECTORY;

		File upDir = new File(fileSavePathStr);
		if(!upDir.exists()){
			upDir.mkdir();
		}

		String result = "";
		XMLRW xmlRW = new XMLRW();
		xmlRW.geoXmlRWCon(fileSavePathStr, null, null, null, null, serverPathStr);
		result = xmlRW.getXmlData("", file_name, upload_type);
		
		Map<String, String> mapFileAttributes = new HashMap<String, String>();
		mapFileAttributes.put("caption", "TITLE");
		mapFileAttributes.put("public_domain", "public");
		mapFileAttributes.put("image_url", file_name);
		mapFileAttributes.put("content", "CONTENT");
		mapFileAttributes.put("dron", "N");

		JSONObject json = new JSONObject();
		Map<String, Object> mapRoot = new HashMap<String, Object>();
		mapRoot.put("filename", file_name);
		mapRoot.put("size", -1);
		mapRoot.put("file_attributes", mapFileAttributes);
		
		List<Object> listRegions = new ArrayList<Object>();

		DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder dBuilder;
		try
		{
			dBuilder = dbFactory.newDocumentBuilder();
			Document doc = dBuilder.parse(new InputSource(new StringReader(result)));
			doc.getDocumentElement().normalize();
			
			NodeList nodes;
			NodeList objs = doc.getElementsByTagName("obj");
			for (int i=0; i<objs.getLength(); i++) {
				Node obj = objs.item(i);
				if (obj != null) {
					Element ele = (Element)obj;

					String id = null;
					String top = null;
					String left = null;
					String xstr = null;
					String ystr = null;
					String linecolor = null;
					String backgroundcolor = null;
					String type = null;

					nodes = ele.getElementsByTagName("id");
					if (nodes != null && nodes.getLength() > 0) id = nodes.item(0).getTextContent();
					nodes = ele.getElementsByTagName("top");
					if (nodes != null && nodes.getLength() > 0) top = nodes.item(0).getTextContent();
					nodes = ele.getElementsByTagName("left");
					if (nodes != null && nodes.getLength() > 0) left = nodes.item(0).getTextContent();
					nodes = ele.getElementsByTagName("xstr");
					if (nodes != null && nodes.getLength() > 0) xstr = nodes.item(0).getTextContent();
					nodes = ele.getElementsByTagName("ystr");
					if (nodes != null && nodes.getLength() > 0) ystr = nodes.item(0).getTextContent();
					nodes = ele.getElementsByTagName("linecolor");
					if (nodes != null && nodes.getLength() > 0) linecolor = nodes.item(0).getTextContent();
					nodes = ele.getElementsByTagName("backgroundcolor");
					if (nodes != null && nodes.getLength() > 0) backgroundcolor = nodes.item(0).getTextContent();
					nodes = ele.getElementsByTagName("type");
					if (nodes != null && nodes.getLength() > 0) type = nodes.item(0).getTextContent();
					
					System.out.print("id: ");
					System.out.println(id);
					System.out.print("top: ");
					System.out.println(top);
					System.out.print("left: ");
					System.out.println(left);
					System.out.print("xstr: ");
					System.out.println(xstr);
					System.out.print("ystr: ");
					System.out.println(ystr);
					System.out.print("linecolor: ");
					System.out.println(linecolor);
					System.out.print("backgroundcolor: ");
					System.out.println(backgroundcolor);
					System.out.print("type: ");
					System.out.println(type);
					
					int nTop = Integer.parseInt(top);
					int nLeft = Integer.parseInt(left);
					String axstr[] = xstr.split("_");
					String aystr[] = ystr.split("_");
					List<Double> nListX = new ArrayList<Double>();
					List<Double> nListY = new ArrayList<Double>();
					for (String s : axstr) nListX.add(Double.parseDouble(s));
					for (String s : aystr) nListY.add(Double.parseDouble(s));

					System.out.print("nTop: ");
					System.out.println(nTop);
					System.out.print("nLeft: ");
					System.out.println(nLeft);
					System.out.print("nListX: ");
					System.out.println(nListX);
					System.out.print("nListY: ");
					System.out.println(nListY);
				
					Map<String, Object> mapRegion = new HashMap<String, Object>();
					Map<String, Object> mapShapeAttributes = new HashMap<String, Object>();
					Map<String, Object> mapImageQuality = new HashMap<String, Object>();
					mapImageQuality.put("good_illumination", "true");
					Map<String, Object> mapRegionAttributes = new HashMap<String, Object>();
					mapRegionAttributes.put("name", "g" + i);
					mapRegionAttributes.put("image_quality", mapImageQuality);
					
					if ("rect".equalsIgnoreCase(type)) {

						mapShapeAttributes.put("name", "rect");
						mapShapeAttributes.put("x", nLeft);
						mapShapeAttributes.put("y", nTop);
						mapShapeAttributes.put("width", nLeft + nListX.get(1));
						mapShapeAttributes.put("height", nTop + nListY.get(1));
						mapRegionAttributes.put("type", "rect");
						
					} else if ("circle".equalsIgnoreCase(type)) {

						mapShapeAttributes.put("name", "ellipse");
						mapShapeAttributes.put("cx", nLeft);
						mapShapeAttributes.put("cy", nTop);
						mapShapeAttributes.put("rx", nLeft + nListX.get(1));
						mapShapeAttributes.put("ry", nTop + nListY.get(1));
						mapShapeAttributes.put("theta", 0);
						mapRegionAttributes.put("type", "ellipse");
						
					} else if ("point".equalsIgnoreCase(type)) {

						mapShapeAttributes.put("name", "polygon");
						mapShapeAttributes.put("all_points_x", nListX);
						mapShapeAttributes.put("all_points_y", nListY);
						mapRegionAttributes.put("type", "polygon");

					}
					
					mapRegion.put("shape_attributes", mapShapeAttributes);
					mapRegion.put("region_attributes", mapRegionAttributes);
					
					listRegions.add(mapRegion);
				}
			}
				
		}
		catch (ParserConfigurationException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		catch (SAXException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		mapRoot.put("regions", listRegions);
		json.put(file_name, mapRoot);
		
		//setContentType �� ���� �����ϰ� getWriter		
		response.setContentType("application/json;charset=utf-8");
		response.setHeader("Content-Disposition", "attachment;filename="+file_name.replaceAll(".xml", "")+".vgg.json");
		PrintWriter out = response.getWriter();
		out.print(json);
	}

	@RequestMapping(value = "/geoImageImport.do", method = RequestMethod.POST)
	public void geoImageImport(HttpServletRequest request, HttpServletResponse response) throws IOException {

		System.out.println("GeoCMS :: geoImageImport");

		request.setCharacterEncoding("utf-8");
		response.setContentType("text/xml;charset=utf-8");
		
		String file_url = request.getParameter("file_url");
		String file_name = file_url;

		if (!(file_url != null && file_url.length() > 0)) {
			return;
		}
		int lindex = file_url.lastIndexOf(".");
		if (lindex > 0) {
			file_name = file_url.substring(0, lindex) + ".xml";
		}

		JSONParser parser = new JSONParser();
		StringWriter writer = new StringWriter();

		String fileSavePathStr = request.getSession().getServletContext().getRealPath("/");
		fileSavePathStr = fileSavePathStr.substring(0,fileSavePathStr.length()-1) + File.separator + UPLOAD_DIRECTORY;

		boolean bXml = false;
		XMLRW xmlRW = new XMLRW();
		xmlRW.geoXmlRWCon(fileSavePathStr, null, null, null, null, "upload");
		String strXml = xmlRW.getXmlData(null, file_name, "GeoPhoto");
		if (strXml != null && strXml.length() > 0) {
			strXml = strXml.trim();
			if (strXml.startsWith("<?xml") && strXml.endsWith("</GeoCMS>")) {
				bXml = true;
			}
		}
		
		if (bXml) {
			int nIdx = strXml.lastIndexOf("</GeoCMS>");
			if (nIdx > 0) {
				writer.write(strXml.substring(0, nIdx));
			}
		}
		else {
			writer.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
			writer.write("<GeoCMS>\n");
		}
		
		try
		{
			DiskFileItemFactory factory = new DiskFileItemFactory();
			factory.setSizeThreshold(MEMORY_THRESHOLD);
			factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
			
			ServletFileUpload upload = new ServletFileUpload(factory);
			upload.setFileSizeMax(MAX_FILE_SIZE);
			upload.setSizeMax(MAX_REQUEST_SIZE);
			String uploadPath = request.getSession().getServletContext().getRealPath("") + File.separator + TEMP_DIRECTORY;

			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists()) {
				uploadDir.mkdir();
			}
			
			List<FileItem> fileItems = upload.parseRequest(request);
			if (fileItems != null && fileItems.size() > 0) {
				for (FileItem item : fileItems) {
					if (!item.isFormField()) {

						String fileName = new File(item.getName()).getName();
						InputStream jsonfile = item.getInputStream();
						Reader reader = new InputStreamReader(jsonfile);
						JSONObject jsonObject = (JSONObject)parser.parse(reader);
						
						JSONObject objData = (JSONObject) jsonObject.get("data");
						if (objData != null) {
							JSONObject objTaskResult = (JSONObject) objData.get("task_result");
							if (objTaskResult != null) {
								JSONArray features = (JSONArray) objTaskResult.get("features");
								if (features != null) {
									Iterator<JSONObject> itFeatures = features.iterator();
									while(itFeatures.hasNext()) {
										JSONObject feature = itFeatures.next();
										if (feature != null) {
											System.out.println("==> Feature");
											
											// obj type 2(g)
											String xgsId = "g"; // geometry
											Long xglTop = 0L;
											Long xglLeft = 0L;
											List<Long> xgaXstr = new ArrayList<Long>();
											List<Long> xgaYstr = new ArrayList<Long>();
											String xgsLinecolor = "#FF0000"; // 기본값
											String xgsBackgroundcolor = "#FF0000"; // 기본값
											String xgsType = "";
											Long xglFrameline = 75L; // 모르겠음. 기본값.
											Long xglFramestart = 0L; // UrbanAI 값 * 5 / 1000
											Long xglFrameend = 0L; // UrbanAI 값 * 5 / 1000

											
											String sType = (String) feature.get("type");
											System.out.println("type : " + sType);
											String sCategory = (String) feature.get("category");
											System.out.println("category : " + sCategory);
											Double dWeights = (Double) feature.get("weights");
											System.out.println("weights : " + dWeights);

											JSONObject objGeometry = (JSONObject) feature.get("geometry");
											if (objGeometry != null) {
												System.out.print("  ");
												System.out.println("==> geometry");

												String sgType = (String) objGeometry.get("type");
												System.out.print("  ");
												System.out.println("type : " + sgType);
												JSONArray coordinates = (JSONArray) objGeometry.get("coordinates");
												if (coordinates != null && coordinates.size() >= 2) {
													Double c1 = (Double) coordinates.get(0);
													Double c2 = (Double) coordinates.get(1);
													System.out.print("  ");
													System.out.println("coordinates : " + c1 + " , " + c2);
												}
											}
											
											JSONObject objProperties = (JSONObject) feature.get("properties");
											if (objProperties != null) {
												System.out.print("  ");
												System.out.println("==> properties");

												Long sId = (Long) objProperties.get("id");
												System.out.print("  ");
												System.out.println("id : " + sId);
												String sAnnotationText = (String) objProperties.get("annotationText");
												System.out.print("  ");
												System.out.println("annotationText : " + sAnnotationText);
												String sUri = (String) objProperties.get("uri");
												System.out.print("  ");
												System.out.println("uri : " + sUri);
												String sWidth = (String) objProperties.get("width");
												System.out.print("  ");
												System.out.println("width : " + sWidth);
												String sHeight = (String) objProperties.get("height");
												System.out.print("  ");
												System.out.println("height : " + sHeight);

												long lWidth = sWidth != null ? Long.parseLong(sWidth) : 0L;
												long lHeight = sHeight != null ? Long.parseLong(sHeight) : 0L;
												
												JSONObject objAreaInImageJSON = (JSONObject) objProperties.get("areaInInImageJSON");
												if (objAreaInImageJSON != null) {
													System.out.print("    ");
													System.out.println("==> areaInInImageJSON");

													String saType = (String) objAreaInImageJSON.get("type");
													System.out.print("    ");
													System.out.println("type : " + saType);

													// for xml
													Long lXMin = Long.MAX_VALUE;
													Long lYMin = Long.MAX_VALUE;

													JSONArray coordinates = (JSONArray) objAreaInImageJSON.get("coordinates");
													if (coordinates != null) {
														Iterator<JSONArray> itCoordinates = coordinates.iterator();
														while(itCoordinates.hasNext()) {
															JSONArray arCood = itCoordinates.next();
															if (arCood != null && arCood.size() >= 2) {
																Double c1 = (Double) arCood.get(0);
																Double c2 = (Double) arCood.get(1);
																System.out.print("    ");
																System.out.println("coordinates : " + c1 + " , " + c2);
																
																// W:H = w:h
																// Wh = Hw
																// h = Hw/W
//																long c11 = (long)(SCREEN_WIDTH * c1 / lWidth);
//																long c22 = (long)(SCREEN_HEIGHT * c2 / lHeight);
																
																long c11 = c1.longValue();
																long c22 = c2.longValue();
																// for xml
																
																xgaXstr.add(c11);
																xgaYstr.add(c22);
																if (c11 < lXMin) lXMin = c11;
																if (c22 < lYMin) lYMin = c22;
															}
														}
													}
													
													// for xml
													xglTop = lYMin != Long.MAX_VALUE ? lYMin : 0L;
													xglLeft = lXMin != Long.MAX_VALUE ? lXMin : 0L;

													// for xml
													if ("Polygon".equalsIgnoreCase(saType)) {
														xgsType = "point";
													}
													else {
														continue;
													}
												}

												JSONObject objAnnotationJSON = (JSONObject) objProperties.get("annotationJSON");
												if (objAnnotationJSON != null) {
													System.out.print("    ");
													System.out.println("==> annotationJSON");

													String sModel = (String) objAnnotationJSON.get("model");
													System.out.print("    ");
													System.out.println("model : " + sModel);
													String sClassId = (String) objAnnotationJSON.get("classId").toString();
													System.out.print("    ");
													System.out.println("classId : " + sClassId);
													String sClassName = (String) objAnnotationJSON.get("className");
													System.out.print("    ");
													System.out.println("className : " + sClassName);
												}

												JSONArray period = (JSONArray) objProperties.get("period");
												if (period != null && period.size() >= 2) {
													Long c1 = (Long) period.get(0);
													Long c2 = (Long) period.get(1);
													System.out.print("    ");
													System.out.println("period : " + c1 + " , " + c2);
													
													// xml
													xglFramestart = c1 * 5 / 1000;
													xglFrameend = c2 * 5 / 1000;
												}
											}
											System.out.println("");
											
											// write to xml
											writer.write("<obj>\n");

											// write to xml
											writer.write("<id>" + xgsId + "</id>\n");
											writer.write("<top>" + xglTop + "</top>\n");
											writer.write("<left>" + xglLeft + "</left>\n");
											writer.write("<xstr>" + StringUtils.join(xgaXstr, "_") + "</xstr>\n");
											writer.write("<ystr>" + StringUtils.join(xgaYstr, "_") + "</ystr>\n");
											writer.write("<linecolor>" + xgsLinecolor + "</linecolor>\n");
											writer.write("<backgroundcolor>" + xgsBackgroundcolor + "</backgroundcolor>\n");
											writer.write("<type>" + xgsType + "</type>\n");
											writer.write("<frameline>" + xglFrameline + "</frameline>\n");
											writer.write("<framestart>" + xglFramestart + "</framestart>\n");
											writer.write("<frameend>" + xglFrameend + "</frameend>\n");
											
											// write to xml
											writer.write("</obj>\n");
										}
									}
								} // features
							} // objTaskResult
						} // objData
					}
				}
			}
		}
		catch (Exception e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		writer.write("</GeoCMS>\n");
		System.out.println("");
		System.out.print(writer.toString());

		String xmlResult = xmlRW.write(null, file_name, writer.toString(), "GeoPhoto");
		if ("XML_SAVE_SUCCESS".equalsIgnoreCase(xmlResult)) {
			response.getWriter().write(writer.toString());
		}
	}

	@RequestMapping(value = "/geoImageImportDetect.do", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String geoImageImportDetect(HttpServletRequest request, HttpServletResponse response) throws IOException {

		System.out.println("GeoCMS :: geoImageImportDetect");

		request.setCharacterEncoding("utf-8");
		response.setContentType("text/xml;charset=utf-8");
		String file_url = request.getParameter("file_url");
		String file_name = file_url;

		XMLRW xmlRW = new XMLRW();
		JSONParser parser = new JSONParser();
		StringWriter writer = new StringWriter();

		// 결과값.
		JSONObject jsonResult = new JSONObject();
		int nResultCode = 100;
		// code
		String m100 = "success";
		String m201 = "file_url empty";
		String m301 = "HttpConnection not response 1st";
		String m302 = "2nd request url not found";
		String m303 = "HttpConnection not response 2nd";
		String m304 = "queue not finish during 5minute";
		String m305 = "xml write failed";
		
		
		if (file_url != null && file_url.length() > 0) {

			int lindex = file_url.lastIndexOf(".");
			if (lindex > 0) {
				file_name = file_url.substring(0, lindex) + ".xml";
			}

			String fileSavePathStr = request.getSession().getServletContext().getRealPath("/");
			fileSavePathStr = fileSavePathStr.substring(0,fileSavePathStr.length()-1) + File.separator + UPLOAD_DIRECTORY;

			boolean bXml = false;
			xmlRW.geoXmlRWCon(fileSavePathStr, null, null, null, null, "upload");
			String strXml = xmlRW.getXmlData(null, file_name, "GeoPhoto");
			if (strXml != null && strXml.length() > 0) {
				strXml = strXml.trim();
				if (strXml.startsWith("<?xml") && strXml.endsWith("</GeoCMS>")) {
					bXml = true;
				}
			}
			
			if (bXml) {
				int nIdx = strXml.lastIndexOf("</GeoCMS>");
				if (nIdx > 0) {
					writer.write(strXml.substring(0, nIdx));
				}
			}
			else {
				writer.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
				writer.write("<GeoCMS>\n");
			}
			
			HttpURLConnection con = null;
			try
			{
				String uploadPath = request.getSession().getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY + File.separator + "GeoPhoto" + File.separator + "detect";
				File uploadDir = new File(uploadPath);
				if (!uploadDir.exists()) {
					uploadDir.mkdir();
				}
				
				String surl = request.getRequestURL().toString().replace(request.getRequestURI(),"");

				// 1차 요청 - requets
				String url = "http://djr.urbanai.net/task?url="+surl+"/GeoCMS/upload/GeoPhoto/"+file_url+"&model_name=mscoco_maskrcnn&file_type=image";
				//String url = "http://djr.urbanai.net/task?url=http://106.246.9.61:8080/GeoCMS/upload/GeoPhoto/"+file_url+"&model_name=mscoco_maskrcnn&file_type=image";
				URL obj = new URL(url);
				con = (HttpURLConnection) obj.openConnection();
				con.setRequestMethod("GET");
				con.setRequestProperty("User-Agent", "Mozilla/5.0");
				int responseCode = con.getResponseCode();

				System.out.println("\nSending 'GET' request to URL : " + url);
				System.out.println("Response Code : " + responseCode);
				if (responseCode == 200 || responseCode == 202) {

					BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
					String url2 = urbanRequest(in);
					in.close();
					con.disconnect();

					// 2차 요청 - task url
					if (url2 != null && url2.length() > 0) {

						// 2초 이상 sleep - manual
						Thread.sleep(1000 * 2);
						
						boolean bParseOk = false;
						boolean bTimeEnd = false;
						long timeStart = System.currentTimeMillis();

						obj = new URL(url2);
						do
						{
							con = (HttpURLConnection) obj.openConnection();
							con.setRequestMethod("GET");
							con.setRequestProperty("User-Agent", "Mozilla/5.0");
							responseCode = con.getResponseCode();

							System.out.println("\nSending 'GET' request to URL2 : " + url2);
							System.out.println("Response Code : " + responseCode);

							// 응답이 없는 경우 종료.
							if (responseCode == 200 || responseCode == 202) {

								in = new BufferedReader(new InputStreamReader(con.getInputStream()));
								JSONObject jsonObject = (JSONObject)parser.parse(in);
								boolean chk = urbanCheck(jsonObject); // 서버에서 큐 작업이 정상 완료되었는지 확인.
								in.close();
								if (chk) {
									bParseOk = urbanParse(writer, jsonObject); // 작업 정상인경우, 파싱 작업 진행.
								}
								
								// 시간체크 : 20분 경과 종료. - 메뉴얼
								// 현재 5분 설정
								long timeEnd = System.currentTimeMillis();
								long sec = (timeEnd - timeStart) / 1000 / 60;
								bTimeEnd = sec > 5;
							} // end if for responseCode 2nd
							else
							{
								nResultCode = 303;
								jsonResult.put("Code", nResultCode);
								jsonResult.put("Message", m304);
								break;
							}
							con.disconnect();
							// 1sec delay
							Thread.sleep(1000 * 1);
						}
						while(!bParseOk && !bTimeEnd);
						
						if (bTimeEnd) {
							nResultCode = 304;
							jsonResult.put("Code", nResultCode);
							jsonResult.put("Message", m304);
						}
					} // end if - 2차 요청	
					else
					{
						nResultCode = 302;
						jsonResult.put("Code", nResultCode);
						jsonResult.put("Message", m302);
					}
				} // end if for responseCode 1st
				else
				{
					nResultCode = 301;
					jsonResult.put("Code", nResultCode);
					jsonResult.put("Message", m301);
				}
			}
			catch (Exception e)
			{
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			writer.write("</GeoCMS>\n");
			System.out.println("");
			System.out.print(writer.toString());
		} // end if for file_url
		else
		{
			nResultCode = 201;
			jsonResult.put("Code", nResultCode);
			jsonResult.put("Message", m201);
		}

		if (nResultCode == 100) {

			String xmlResult = xmlRW.write(null, file_name, writer.toString(), "GeoPhoto");
			if (!"XML_SAVE_SUCCESS".equalsIgnoreCase(xmlResult)) {
				nResultCode = 305;
				jsonResult.put("Code", nResultCode);
				jsonResult.put("Message", m305);
			}
			else
			{
				jsonResult.put("Code", nResultCode);
				jsonResult.put("Message", m305);
				jsonResult.put("xml", xmlResult);
			}
		}

		return jsonResult.toJSONString();
	}
	
	private String urbanRequest(BufferedReader in)
	{
		String sUrl = null;
		if (in == null) {
			return sUrl;
		}

		JSONParser parser = new JSONParser();
		JSONObject jsonObject;
		JSONObject objData;
		try
		{
			jsonObject = (JSONObject)parser.parse(in);
			objData = (JSONObject) jsonObject.get("data");
			String sStatus = (String) jsonObject.get("status");
			if (objData != null && sStatus != null) {
				String sTaskUrl = (String) objData.get("task_url");
				if (sTaskUrl != null && "add task success".equalsIgnoreCase(sStatus)) {
					sUrl = "http://" + sTaskUrl;
				}
			}
		}
		catch (IOException | ParseException e)
		{
			e.printStackTrace();
		}
		return sUrl;
	}

	private boolean urbanCheck(JSONObject jsonObject)
	{
		boolean bRtn = false;
		if (jsonObject == null) {
			return bRtn;
		}

		JSONObject objData = (JSONObject) jsonObject.get("data");
		if (objData != null) {
			String sTaskStatus = (String) objData.get("task_status");
			if (sTaskStatus != null) {
				
				if ("finished".equalsIgnoreCase(sTaskStatus)) {
					bRtn = true;
				}
			} // sTaskStatus
		} // objData

		return bRtn;
	}

	private boolean urbanParse(StringWriter writer, JSONObject jsonObject)
	{
		boolean bRtn = false;
		if (writer == null || jsonObject == null) {
			return bRtn;
		}
		
		JSONObject objData = (JSONObject) jsonObject.get("data");
		if (objData != null) {
			JSONObject objTaskResult = (JSONObject) objData.get("task_result");
			if (objTaskResult != null) {
				JSONArray features = (JSONArray) objTaskResult.get("features");
				if (features != null) {
					Iterator<JSONObject> itFeatures = features.iterator();
					while(itFeatures.hasNext()) {
						JSONObject feature = itFeatures.next();
						if (feature != null) {
							System.out.println("==> Feature");
							
							// obj type 2(g)
							String xgsId = "g"; // geometry
							Long xglTop = 0L;
							Long xglLeft = 0L;
							List<Long> xgaXstr = new ArrayList<Long>();
							List<Long> xgaYstr = new ArrayList<Long>();
							String xgsLinecolor = "#FF0000"; // 기본값
							String xgsBackgroundcolor = "#FF0000"; // 기본값
							String xgsType = "";
							Long xglFrameline = 75L; // 모르겠음. 기본값.
							Long xglFramestart = 0L; // UrbanAI 값 * 5 / 1000
							Long xglFrameend = 0L; // UrbanAI 값 * 5 / 1000

							String sType = (String) feature.get("type");
							System.out.println("type : " + sType);
							String sCategory = (String) feature.get("category");
							System.out.println("category : " + sCategory);
							Double dWeights = (Double) feature.get("weights");
							System.out.println("weights : " + dWeights);

							JSONObject objGeometry = (JSONObject) feature.get("geometry");
							if (objGeometry != null) {
								System.out.print("  ");
								System.out.println("==> geometry");

								String sgType = (String) objGeometry.get("type");
								System.out.print("  ");
								System.out.println("type : " + sgType);
								JSONArray coordinates = (JSONArray) objGeometry.get("coordinates");
								if (coordinates != null && coordinates.size() >= 2) {
									Double c1 = (Double) coordinates.get(0);
									Double c2 = (Double) coordinates.get(1);
									System.out.print("  ");
									System.out.println("coordinates : " + c1 + " , " + c2);
								}
							}
							
							JSONObject objProperties = (JSONObject) feature.get("properties");
							if (objProperties != null) {
								System.out.print("  ");
								System.out.println("==> properties");

								Long sId = (Long) objProperties.get("id");
								System.out.print("  ");
								System.out.println("id : " + sId);
								String sAnnotationText = (String) objProperties.get("annotationText");
								System.out.print("  ");
								System.out.println("annotationText : " + sAnnotationText);
								String sUri = (String) objProperties.get("uri");
								System.out.print("  ");
								System.out.println("uri : " + sUri);
								String sWidth = (String) objProperties.get("width");
								System.out.print("  ");
								System.out.println("width : " + sWidth);
								String sHeight = (String) objProperties.get("height");
								System.out.print("  ");
								System.out.println("height : " + sHeight);

								long lWidth = sWidth != null ? Long.parseLong(sWidth) : 0L;
								long lHeight = sHeight != null ? Long.parseLong(sHeight) : 0L;
								
								JSONObject objAreaInImageJSON = (JSONObject) objProperties.get("areaInInImageJSON");
								if (objAreaInImageJSON != null) {
									System.out.print("    ");
									System.out.println("==> areaInInImageJSON");

									String saType = (String) objAreaInImageJSON.get("type");
									System.out.print("    ");
									System.out.println("type : " + saType);

									// for xml
									Long lXMin = Long.MAX_VALUE;
									Long lYMin = Long.MAX_VALUE;

									JSONArray coordinates = (JSONArray) objAreaInImageJSON.get("coordinates");
									if (coordinates != null) {
										Iterator<JSONArray> itCoordinates = coordinates.iterator();
										while(itCoordinates.hasNext()) {
											JSONArray arCood = itCoordinates.next();
											if (arCood != null && arCood.size() >= 2) {
												Double c1 = (Double) arCood.get(0);
												Double c2 = (Double) arCood.get(1);
												System.out.print("    ");
												System.out.println("coordinates : " + c1 + " , " + c2);
												
												// W:H = w:h
												// Wh = Hw
												// h = Hw/W
//																long c11 = (long)(SCREEN_WIDTH * c1 / lWidth);
//																long c22 = (long)(SCREEN_HEIGHT * c2 / lHeight);
												
												long c11 = c1.longValue();
												long c22 = c2.longValue();
												// for xml
												
												xgaXstr.add(c11);
												xgaYstr.add(c22);
												if (c11 < lXMin) lXMin = c11;
												if (c22 < lYMin) lYMin = c22;
											}
										}
									}
									
									// for xml
									xglTop = lYMin != Long.MAX_VALUE ? lYMin : 0L;
									xglLeft = lXMin != Long.MAX_VALUE ? lXMin : 0L;

									// for xml
									if ("Polygon".equalsIgnoreCase(saType)) {
										xgsType = "point";
									}
									else {
										continue;
									}
								}

								JSONObject objAnnotationJSON = (JSONObject) objProperties.get("annotationJSON");
								if (objAnnotationJSON != null) {
									System.out.print("    ");
									System.out.println("==> annotationJSON");

									String sModel = (String) objAnnotationJSON.get("model");
									System.out.print("    ");
									System.out.println("model : " + sModel);
									String sClassId = (String) objAnnotationJSON.get("classId").toString();
									System.out.print("    ");
									System.out.println("classId : " + sClassId);
									String sClassName = (String) objAnnotationJSON.get("className");
									System.out.print("    ");
									System.out.println("className : " + sClassName);
								}

								JSONArray period = (JSONArray) objProperties.get("period");
								if (period != null && period.size() >= 2) {
									Long c1 = (Long) period.get(0);
									Long c2 = (Long) period.get(1);
									System.out.print("    ");
									System.out.println("period : " + c1 + " , " + c2);
									
									// xml
									xglFramestart = c1 * 5 / 1000;
									xglFrameend = c2 * 5 / 1000;
								}
							}
							System.out.println("");
							
							// write to xml
							writer.write("<obj>\n");

							// write to xml
							writer.write("<id>" + xgsId + "</id>\n");
							writer.write("<top>" + xglTop + "</top>\n");
							writer.write("<left>" + xglLeft + "</left>\n");
							writer.write("<xstr>" + StringUtils.join(xgaXstr, "_") + "</xstr>\n");
							writer.write("<ystr>" + StringUtils.join(xgaYstr, "_") + "</ystr>\n");
							writer.write("<linecolor>" + xgsLinecolor + "</linecolor>\n");
							writer.write("<backgroundcolor>" + xgsBackgroundcolor + "</backgroundcolor>\n");
							writer.write("<type>" + xgsType + "</type>\n");
							writer.write("<frameline>" + xglFrameline + "</frameline>\n");
							writer.write("<framestart>" + xglFramestart + "</framestart>\n");
							writer.write("<frameend>" + xglFrameend + "</frameend>\n");
							
							// write to xml
							writer.write("</obj>\n");
						}
					}
				} // features
			} // objTaskResult
		} // objData
		bRtn = true;

		return bRtn;
	}
	
	@RequestMapping(value = "/geoImageExport.do")
	public void geoImageExport(HttpServletRequest request, HttpServletResponse response) throws IOException {

		request.setCharacterEncoding("utf-8");
		System.out.println("geoImageExport req file name : " + request.getParameter("file_name"));

		String upload_type = null;
		String file_name = null;
		
		String kind = request.getParameter("kind");
		String[] buf = request.getParameter("file_name").split("\\/");
		if (buf != null && buf.length >= 1) {
			upload_type = buf[0];
			file_name = buf[1];
		}
		String serverPathStr = "upload";
		String fileSavePathStr = request.getSession().getServletContext().getRealPath("/");
		fileSavePathStr = fileSavePathStr.substring(0,fileSavePathStr.length()-1) + File.separator + UPLOAD_DIRECTORY;

		File upDir = new File(fileSavePathStr);
		if(!upDir.exists()){
			upDir.mkdir();
		}

		String result = "";
		XMLRW xmlRW = new XMLRW();
		xmlRW.geoXmlRWCon(fileSavePathStr, null, null, null, null, serverPathStr);
		result = xmlRW.getXmlData("", file_name, upload_type);
		
		// UrbanAI json format
		List<Object> listFeatures = new ArrayList<Object>();
		
		Map<String, Object> mapTaskResult = new HashMap<String, Object>();
		mapTaskResult.put("features", listFeatures);
		mapTaskResult.put("type", "FeatureCollection");
		
		Map<String, Object> mapData = new HashMap<String, Object>();
		mapData.put("message","Task queued at Thu, 09 Jan 2020 01:38:34 0 jobs queued");
		mapData.put("task_id", "4c8e636e-4231-4952-aca4-46d67937e38c");
		mapData.put("task_result", mapTaskResult);
		mapData.put("task_status", "finished");
 
		JSONObject json = new JSONObject();
		json.put("data", mapData);
		json.put("status", "success");

		DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder dBuilder;
		try
		{
			dBuilder = dbFactory.newDocumentBuilder();
			Document doc = dBuilder.parse(new InputSource(new StringReader(result)));
			doc.getDocumentElement().normalize();
			
			NodeList nodes;
			NodeList objs = doc.getElementsByTagName("obj");
			for (int i=0; i<objs.getLength(); i++) {
				Node obj = objs.item(i);
				if (obj != null) {
					Element ele = (Element)obj;

					String id = null;
					String top = null;
					String left = null;
					String xstr = null;
					String ystr = null;
					String linecolor = null;
					String backgroundcolor = null;
					String type = null;

					nodes = ele.getElementsByTagName("id");
					if (nodes != null && nodes.getLength() > 0) id = nodes.item(0).getTextContent();
					nodes = ele.getElementsByTagName("top");
					if (nodes != null && nodes.getLength() > 0) top = nodes.item(0).getTextContent();
					nodes = ele.getElementsByTagName("left");
					if (nodes != null && nodes.getLength() > 0) left = nodes.item(0).getTextContent();
					nodes = ele.getElementsByTagName("xstr");
					if (nodes != null && nodes.getLength() > 0) xstr = nodes.item(0).getTextContent();
					nodes = ele.getElementsByTagName("ystr");
					if (nodes != null && nodes.getLength() > 0) ystr = nodes.item(0).getTextContent();
					nodes = ele.getElementsByTagName("linecolor");
					if (nodes != null && nodes.getLength() > 0) linecolor = nodes.item(0).getTextContent();
					nodes = ele.getElementsByTagName("backgroundcolor");
					if (nodes != null && nodes.getLength() > 0) backgroundcolor = nodes.item(0).getTextContent();
					nodes = ele.getElementsByTagName("type");
					if (nodes != null && nodes.getLength() > 0) type = nodes.item(0).getTextContent();
					
					System.out.print("id: ");
					System.out.println(id);
					System.out.print("top: ");
					System.out.println(top);
					System.out.print("left: ");
					System.out.println(left);
					System.out.print("xstr: ");
					System.out.println(xstr);
					System.out.print("ystr: ");
					System.out.println(ystr);
					System.out.print("linecolor: ");
					System.out.println(linecolor);
					System.out.print("backgroundcolor: ");
					System.out.println(backgroundcolor);
					System.out.print("type: ");
					System.out.println(type);
					
					if (!"point".equalsIgnoreCase(type)) {
						System.out.println("============> point 이외의 타입은 제외.");
						continue;
					}
					
					int nTop = Integer.parseInt(top);
					int nLeft = Integer.parseInt(left);
					String axstr[] = xstr.split("_");
					String aystr[] = ystr.split("_");
					List<Integer> nListX = new ArrayList<Integer>();
					List<Integer> nListY = new ArrayList<Integer>();
//					for (String s : axstr) nListX.add(Integer.parseInt(s) + nLeft);
//					for (String s : aystr) nListY.add(Integer.parseInt(s) + nTop);
					for (String s : axstr) nListX.add(Integer.parseInt(s));
					for (String s : aystr) nListY.add(Integer.parseInt(s));

					System.out.print("nTop: ");
					System.out.println(nTop);
					System.out.print("nLeft: ");
					System.out.println(nLeft);
					System.out.print("nListX: ");
					System.out.println(nListX);
					System.out.print("nListY: ");
					System.out.println(nListY);
				
					Map<String, Object> mapFeature = new HashMap<String, Object>();
					Map<String, Object> mapGeometry = new HashMap<String, Object>();
					Map<String, Object> mapProperties = new HashMap<String, Object>();
					Map<String, Object> mapAnnotationJSON = new HashMap<String, Object>();
					Map<String, Object> mapAreaInInImageJSON = new HashMap<String, Object>();
					List<String> listInstant = new ArrayList<String>();
					List<Object> listCoordinates = new ArrayList<Object>();
					
					if (nListX != null && nListY != null && nListX.size() == nListY.size()) {
						for (int ii=0; ii<nListX.size(); ii++) {
							List<Double> listTemp = new ArrayList<Double>();
							listTemp.add(Double.valueOf(nListX.get(ii)));
							listTemp.add(Double.valueOf(nListY.get(ii)));
							listCoordinates.add(listTemp);
						}
					}

					mapFeature.put("geometry", mapGeometry);
						mapGeometry.put("coordinates", null);
						mapGeometry.put("type", "Point");
					mapFeature.put("properties", mapProperties);
						mapProperties.put("annoationText", "person:0");
						mapProperties.put("annotationJSON", mapAnnotationJSON);
							mapAnnotationJSON.put("classId", 1);
							mapAnnotationJSON.put("className",  "person");
							mapAnnotationJSON.put("model", "mscoco_maskrcnn");
						mapProperties.put("areaInInImageJSON", mapAreaInInImageJSON);
							mapAreaInInImageJSON.put("coordinates", listCoordinates);
							mapAreaInInImageJSON.put("score", 0.9993888139724731);
							mapAreaInInImageJSON.put("type", "polygon");
						mapProperties.put("id", 0);
						mapProperties.put("instant", listInstant);
							listInstant.add("2000-01-01 00:00:00");
							listInstant.add("2000-01-01 00:00:00");
						mapProperties.put("uri", "http://turbo.hopto.org:8127/GeoCMS/upload/GeoPhoto/"+file_name+"_thumbnail_600.png");
					mapFeature.put("type", "Feature");

					/*
					if ("rect".equalsIgnoreCase(type)) {

						mapShapeAttributes.put("name", "rect");
						mapShapeAttributes.put("x", nLeft);
						mapShapeAttributes.put("y", nTop);
						mapShapeAttributes.put("width", nLeft + nListX.get(1));
						mapShapeAttributes.put("height", nTop + nListY.get(1));
						mapRegionAttributes.put("type", "rect");
						
					} else if ("circle".equalsIgnoreCase(type)) {

						mapShapeAttributes.put("name", "ellipse");
						mapShapeAttributes.put("cx", nLeft);
						mapShapeAttributes.put("cy", nTop);
						mapShapeAttributes.put("rx", nLeft + nListX.get(1));
						mapShapeAttributes.put("ry", nTop + nListY.get(1));
						mapShapeAttributes.put("theta", 0);
						mapRegionAttributes.put("type", "ellipse");
						
					} else if ("point".equalsIgnoreCase(type)) {

						mapShapeAttributes.put("name", "polygon");
						mapShapeAttributes.put("all_points_x", nListX);
						mapShapeAttributes.put("all_points_y", nListY);
						mapRegionAttributes.put("type", "polygon");

					}*/
					
					listFeatures.add(mapFeature);
				}
			}
				
		}
		catch (ParserConfigurationException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		catch (SAXException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//setContentType �� ���� �����ϰ� getWriter		
		response.setContentType("application/json;charset=utf-8");
		response.setHeader("Content-Disposition", "attachment;filename="+file_name.replaceAll(".xml", "")+".urbanai.json");
		PrintWriter out = response.getWriter();
		out.print(json);
	}
	
}
