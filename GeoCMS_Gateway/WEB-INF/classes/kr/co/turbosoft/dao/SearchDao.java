package kr.co.turbosoft.dao;

import java.util.HashMap;
import java.util.List;

public interface SearchDao {
	public List<Object> selectSearchList(HashMap<String, String> param);//�˻� ����Ʈ ��û
}
