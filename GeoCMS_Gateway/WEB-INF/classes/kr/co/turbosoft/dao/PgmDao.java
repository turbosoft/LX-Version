package kr.co.turbosoft.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface PgmDao
{
	String getLayerTableName(Map<String, String> param);

	List<Map<String, String>> selectLayerTableColumns(Map<String, String> param);
	List<Map<String, String>> selectProjectRowList(Map<String, String> param);
	List<Map<String, String>> selectLayerUserColumns(Map<String, String> param);
	List<Map<String, String>> selectLayerTableAttrs(Map<String, String> param);

	List<Map<String, String>> getMgeometryColumns(Map<String, String> paramMap);

	List<HashMap<String, Object>> tableviewDataList(Map<String, String> param);
	int tableRowDelete(Map<String, String> param);

	List<Map<String, String>> selectAllLayer();

	int updateTraj(Map<String, String> resultMap);

	int updateSensor(Map<String, String> param2);

	String getLayerColName(Map<String, String> param);

	int updateVideoData(Map<String, String> param2);
}