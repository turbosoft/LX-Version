package kr.co.turbosoft.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.turbosoft.dao.PgmDao;

import org.mybatis.spring.support.SqlSessionDaoSupport;

public class PgmDaoImpl extends SqlSessionDaoSupport implements PgmDao
{
	public String getLayerTableName(Map<String, String> param)
	{
		// TODO Auto-generated method stub
		return getSqlSession().selectOne("pgm.getLayerTableName", param);
	}
	public String getLayerColName(Map<String, String> param)
	{
		// TODO Auto-generated method stub
		return getSqlSession().selectOne("pgm.getLayerColName", param);
	}

	public List<Map<String, String>> selectLayerTableColumns(Map<String, String> param)
	{
		// TODO Auto-generated method stub
		return getSqlSession().selectList("pgm.selectLayerTableColumns", param);
	}
	public List<Map<String, String>> selectProjectRowList(Map<String, String> param)
	{
		// TODO Auto-generated method stub
		return getSqlSession().selectList("pgm.selectProjectRowList", param);
	}
	public List<Map<String, String>> selectLayerUserColumns(Map<String, String> param)
	{
		// TODO Auto-generated method stub
		return getSqlSession().selectList("pgm.selectLayerUserColumns", param);
	}
	public List<Map<String, String>> selectLayerTableAttrs(Map<String, String> param)
	{
		// TODO Auto-generated method stub
		return getSqlSession().selectList("pgm.selectLayerTableAttrs", param);
	}
	public List<Map<String, String>> selectAllLayer()
	{
		// TODO Auto-generated method stub
		return getSqlSession().selectList("pgm.selectAllLayer");
	}

	public List<Map<String, String>> getMgeometryColumns(Map<String, String> paramMap)
	{
		// TODO Auto-generated method stub
		return getSqlSession().selectList("pgm.getMgeometryColumns", paramMap);
	}
	public List<HashMap<String, Object>> tableviewDataList(Map<String, String> param)
	{
		// TODO Auto-generated method stub
		return getSqlSession().selectList("pgm.tableviewDataList", param);
	}
	public int tableRowDelete(Map<String, String> param)
	{
		// TODO Auto-generated method stub
		int resultIntegerValue = getSqlSession().delete("pgm.tableRowDelete", param);
		
		return resultIntegerValue;
	}

	public int updateVideoData(Map<String, String> resultMap) 
	{ 
		int resultIntegerValue = getSqlSession().update("pgm.updateVideoData", resultMap);
		
		return resultIntegerValue;
	}
	public int updateTraj(Map<String, String> resultMap) 
	{ 
		int resultIntegerValue = getSqlSession().update("pgm.updateTraj", resultMap);
				
		return resultIntegerValue;
	}
	public int updateSensor(Map<String, String> param) 
	{ 
		int resultIntegerValue = getSqlSession().update("pgm.updateSensor", param);
		
		return resultIntegerValue;
	}
}