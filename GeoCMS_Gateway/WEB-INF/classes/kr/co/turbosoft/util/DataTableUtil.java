package kr.co.turbosoft.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.ModelAndView;

public class DataTableUtil
{

	private String colName = "";

	private String searchValue = "";

	private String searchDateStart = ""; // 날짜 검색 시작

	private String searchDateEnd = ""; // 날짜 검색 끝

	private String orderColName = ""; // order by 컬럼명

	private String tbName = "";

	private String type = "";

	private String sStart = "";

	private String sAmount = "";

	private String sCol = "";

	private String sdir = "";

	private String sDraw = "";

	private String searchText = "";

	private int amount = 10;

	private int start = 0;

	private int col = 0;

	private int total = 0;

	private int end = 0;

	private String linearityStart;

	private String linearityEnd;

	private String linearityOne;

	String strSequence;

	String strYear1;

	String strYear2;

	String strAge1;

	String strAge2;

	String strTurn1;

	String strTurn2;

	// 과제관리 추가 파라메터
	String searchTurn1;

	String searchTurn2;

	String searchSDate;

	String searchEDate;

	String searchHosps;

	public Map makeSearchMap(HttpServletRequest request)
	{

		Map<String, Object> mapReturn = new HashMap<String, Object>();
		// 전체 테이블 컬럼명
		List<String> listColumns = new ArrayList<String>();
		HashMap<String, Object> searchMap = new HashMap<String, Object>();
		// 임시 변수들..

		for (int i = 0;; i++)
		{
			colName = request.getParameter("columns[" + i + "][data]");
			if (colName != null && colName.length() > 0)
			{
				// SecureCoding
				colName = colName.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
				listColumns.add(colName);

				String searchType = request.getParameter("searchType");
				if (searchType != null && searchType.length() > 0)
				{
					// SecureCoding
					searchType = searchType.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
					searchMap.put("searchType", searchType);
				}

				// 커뮤니티 카테고리 확인

				String type = request.getParameter("TYPE");
				if (type != null && type.length() > 0)
				{
					// SecureCoding
					searchType = type.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
					searchMap.put("TYPE", type);
				}

				// 개별 검색 확인

				searchValue = request.getParameter("columns[" + i + "][search][value]");
				if (searchValue != null && searchValue.length() > 0)
				{
					// SecureCoding
					searchValue = searchValue.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
					if (searchValue.indexOf("//") > 0)
					{
						searchDateStart = searchValue.split("//")[0];
						searchDateEnd = searchValue.split("//")[1];
						searchMap.put(colName+"_START", searchDateStart);
						searchMap.put(colName+"_END", searchDateEnd);
					}
					else
					{
						searchMap.put(colName, searchValue);
					}
				}
			}
			else
			{
				break;
			}
		}

		sStart = request.getParameter("start");
		sAmount = request.getParameter("length");
		sCol = request.getParameter("order[0][column]");
		sdir = request.getParameter("order[0][dir]");
		sDraw = request.getParameter("draw");
		searchText = request.getParameter("search[value]");
		tbName = request.getParameter("tbName");

		// SecureCoding
		if (sStart != null)
		{
			sStart = sStart.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (sAmount != null)
		{
			sAmount = sAmount.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (sCol != null)
		{
			sCol = sCol.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (sdir != null)
		{
			sdir = sdir.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (sDraw != null)
		{
			sDraw = sDraw.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (searchText != null)
		{
			searchText = searchText.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (tbName != null)
		{
			tbName = tbName.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
			searchMap.put("tbName", tbName); // 테이블명
		}

		searchMap.put("searchText", searchText); // like 검색에 쓰일 text

		String dir = (sdir == null || sdir.equals("asc")) ? "asc" : "desc";

		if (sStart != null)
		{ // 페이지 시작 번호
			try
			{
				start = Integer.parseInt(sStart);
			}
			catch (NumberFormatException e)
			{
				start = 0;
			}
			start = start > 0 ? start : 0;
		}
		if (sAmount != null)
		{ // 페이지 라인 수
			try
			{
				amount = Integer.parseInt(sAmount);
			}
			catch (NumberFormatException e)
			{
				amount = 0;
			}
			amount = (amount >= 10 || amount <= 100) ? amount : 10;
		}
		if (start < Integer.MAX_VALUE && amount < Integer.MAX_VALUE && (start + amount) < Integer.MAX_VALUE)
		{
			end = start + amount; //
		}

		if (sCol != null)
		{ // 검색 컬럼
			try
			{
				col = Integer.parseInt(sCol);
			}
			catch (NumberFormatException e)
			{
				col = 0;
			}
			col = (col >= 0 || col <= listColumns.size()) ? col : 0;
		}

		// 정렬 컬럼
		if (listColumns != null && listColumns.size() > col)
		{
			orderColName = listColumns.get(col);
		}

		if ((start + 1) < Integer.MAX_VALUE)
		{
			searchMap.put("start", start + 1);
		}
		searchMap.put("end", end);
		searchMap.put("orderColName", orderColName);
		searchMap.put("dir", dir);

		return searchMap;
	}

	public Map makeSearchMapExcel(HttpServletRequest request)
	{

		Map<String, Object> mapReturn = new HashMap<String, Object>();
		// 전체 테이블 컬럼명
		List<String> listColumns = new ArrayList<String>();
		HashMap<String, Object> searchMap = new HashMap<String, Object>();
		// 임시 변수들..
		colName = "";
		searchValue = "";
		searchDateStart = ""; // 날짜 검색 시작
		searchDateEnd = ""; // 날짜 검색 끝
		linearityStart = ""; // 충실도 시작
		linearityEnd = ""; // 충실도 끝
		linearityOne = ""; // 충실도 한개만 입력
		orderColName = ""; // order by 컬럼명

		for (int i = 0;; i++)
		{
			colName = request.getParameter("columns[" + i + "][data]");
			if (colName != null && colName.length() > 0)
			{
				// SecureCoding
				colName = colName.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
				listColumns.add(colName);

				String searchType = request.getParameter("searchType");
				if (searchType != null && searchType.length() > 0)
				{
					// SecureCoding
					searchType = searchType.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
					searchMap.put("searchType", searchType);
				}

				// 개별 검색 확인
				searchValue = request.getParameter("columns[" + i + "][search][value]");
				if (searchValue != null && searchValue.length() > 0)
				{
					// SecureCoding
					searchValue = searchValue.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
					if (searchValue.indexOf("//") > 0)
					{
						searchDateStart = searchValue.split("//")[0];
						searchDateEnd = searchValue.split("//")[1];
						searchMap.put("researchPeriod", "1");
						searchMap.put("searchDateStart", searchDateStart);
						searchMap.put("searchDateEnd", searchDateEnd);
					}
					else if (searchValue.contains("@"))
					{
						String[] linearityArr = searchValue.split("@");
						if (linearityArr != null)
						{
							int lineNum = 0;
							lineNum = linearityArr.length;
							if (lineNum == 1)
							{
								linearityStart = searchValue.split("@")[0];
								searchMap.put("linearityStart", linearityStart);
							}
							else if (lineNum == 2)
							{
								linearityStart = searchValue.split("@")[0];
								linearityEnd = searchValue.split("@")[1];
								searchMap.put("linearityStart", linearityStart);
								searchMap.put("linearityEnd", linearityEnd);
							}
						}
					}
					else
					{
						searchMap.put(colName, searchValue);
					}
				}
			}
			else
			{
				break;
			}
		}

		String sStart = request.getParameter("start");
		String sAmount = request.getParameter("length");
		String sCol = request.getParameter("order[0][column]");
		String sdir = request.getParameter("order[0][dir]");
		String sDraw = request.getParameter("draw");
		String searchText = request.getParameter("search[value]");

		// SecureCoding
		if (sStart != null)
		{
			sStart = sStart.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (sAmount != null)
		{
			sAmount = sAmount.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (sCol != null)
		{
			sCol = sCol.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (sdir != null)
		{
			sdir = sdir.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (sDraw != null)
		{
			sDraw = sDraw.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (searchText != null)
		{
			searchText = searchText.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}

		searchMap.put("searchText", searchText); // like 검색에 쓰일 text

		int amount = 10;
		int start = 0;
		int col = 0;
		int total = 0;
		int end = 0;
		String dir = (sdir == null || sdir.equals("asc")) ? "asc" : "desc";

		if (sStart != null)
		{ // 페이지 시작 번호
			try
			{
				start = Integer.parseInt(sStart);
			}
			catch (NumberFormatException e)
			{
				start = 0;
			}
			start = start > 0 ? start : 0;
		}
		if (sAmount != null)
		{ // 페이지 라인 수
			try
			{
				amount = Integer.parseInt(sAmount);
			}
			catch (NumberFormatException e)
			{
				amount = 0;
			}
			amount = (amount >= 10 || amount <= 100) ? amount : 10;
		}
		if (start < Integer.MAX_VALUE && amount < Integer.MAX_VALUE && (start + amount) < Integer.MAX_VALUE)
		{
			end = start + amount; //
		}

		if (sCol != null)
		{ // 검색 컬럼
			try
			{
				col = Integer.parseInt(sCol);
			}
			catch (NumberFormatException e)
			{
				col = 0;
			}
			col = (col >= 0 || col <= listColumns.size()) ? col : 0;
		}

		// 정렬 컬럼
		if (listColumns != null && listColumns.size() > col)
		{
			orderColName = listColumns.get(col);
		}

		if ((start + 1) < Integer.MAX_VALUE)
		{
			searchMap.put("start", start + 1);
		}
		searchMap.put("end", end);
		searchMap.put("orderColName", orderColName);
		searchMap.put("dir", dir);

		return searchMap;
	}

	public ModelAndView makeDataTable(List<HashMap<String, Object>> resultList)
	{

		Map<String, Object> mapReturn = new HashMap<String, Object>();
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

		ModelAndView modelAndView = new ModelAndView("jsonView", mapReturn);
		return modelAndView;
	}

	public Map makeSearchMapProject(HttpServletRequest request)
	{
		Map<String, Object> mapReturn = new HashMap<String, Object>();
		// 전체 테이블 컬럼명
		List<String> listColumns = new ArrayList<String>();
		Map<String, Object> mapSearch = new HashMap<String, Object>();
		// 임시 변수들..
		colName = "";
		searchValue = "";
		searchDateStart = ""; // 날짜 검색 시작
		searchDateEnd = ""; // 날짜 검색 끝
		orderColName = ""; // order by 컬럼명

		for (int i = 0;; i++)
		{
			colName = request.getParameter("columns[" + i + "][data]");
			if (colName != null && colName.length() > 0)
			{
				// SecureCoding
				colName = colName.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
				listColumns.add(colName);

				String searchType = request.getParameter("searchType");
				if (searchType != null && searchType.length() > 0)
				{
					// SecureCoding
					searchType = searchType.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
					mapSearch.put("searchType", searchType);
				}

				// 개별 검색 확인
				searchValue = request.getParameter("columns[" + i + "][search][value]");
				if (searchValue != null && searchValue.length() > 0)
				{
					// SecureCoding
					searchValue = searchValue.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
					if (searchValue.indexOf("//") > 0)
					{
						searchDateStart = searchValue.split("//")[0];
						searchDateEnd = searchValue.split("//")[1];
						mapSearch.put("researchPeriod", "1");
						mapSearch.put("searchDateStart", searchDateStart);
						mapSearch.put("searchDateEnd", searchDateEnd);
					}
					else
					{
						mapSearch.put(colName, searchValue);
					}
				}
			}
			else
			{
				break;
			}
		}

		sStart = request.getParameter("start");
		sAmount = request.getParameter("length");
		sCol = request.getParameter("order[0][column]");
		sdir = request.getParameter("order[0][dir]");
		sDraw = request.getParameter("draw");
		searchText = request.getParameter("search[value]");

		// 과제관리에서 필요한 파라메터
		strSequence = request.getParameter("SEQUENCE");
		strYear1 = request.getParameter("PR_REQ_YEAR1");
		strYear2 = request.getParameter("PR_REQ_YEAR2");
		strAge1 = request.getParameter("PR_REQ_AGE1");
		strAge2 = request.getParameter("PR_REQ_AGE2");
		strTurn1 = request.getParameter("PR_REQ_TURN1");
		strTurn2 = request.getParameter("PR_REQ_TURN2");
		// 과제관리 추가 파라메터
		searchTurn1 = request.getParameter("SEARCH_TURN1");
		searchTurn2 = request.getParameter("SEARCH_TURN2");
		searchSDate = request.getParameter("SEARCH_SDATE");
		searchEDate = request.getParameter("SEARCH_EDATE");
		searchHosps = request.getParameter("SEARCH_HOSPS");

		// SecureCoding
		if (sStart != null)
		{
			sStart = sStart.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (sAmount != null)
		{
			sAmount = sAmount.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (sCol != null)
		{
			sCol = sCol.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (sdir != null)
		{
			sdir = sdir.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (sDraw != null)
		{
			sDraw = sDraw.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (searchText != null)
		{
			searchText = searchText.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}

		if (strSequence != null)
		{
			strSequence = strSequence.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (strYear1 != null)
		{
			strYear1 = strYear1.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (strYear2 != null)
		{
			strYear2 = strYear2.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (strAge1 != null)
		{
			strAge1 = strAge1.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (strAge2 != null)
		{
			strAge2 = strAge2.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (strTurn1 != null)
		{
			strTurn1 = strTurn1.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (strTurn2 != null)
		{
			strTurn2 = strTurn2.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}

		if (searchTurn1 != null)
		{
			searchTurn1 = searchTurn1.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (searchTurn2 != null)
		{
			searchTurn2 = searchTurn2.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (searchSDate != null)
		{
			searchSDate = searchSDate.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (searchEDate != null)
		{
			searchEDate = searchEDate.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		if (searchHosps != null)
		{
			searchHosps = searchHosps.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
		}
		// SecureCoding

		String[] vstrHosps = null;
		if (searchHosps != null && searchHosps.length() > 0)
		{
			vstrHosps = searchHosps.split("/");
		}

		mapSearch.put("SEQUENCE", strSequence);
		mapSearch.put("PR_REQ_YEAR1", strYear1);
		mapSearch.put("PR_REQ_YEAR2", strYear2);
		mapSearch.put("PR_REQ_AGE1", strAge1);
		mapSearch.put("PR_REQ_AGE2", strAge2);
		mapSearch.put("PR_REQ_TURN1", strTurn1);
		mapSearch.put("PR_REQ_TURN2", strTurn2);

		mapSearch.put("SEARCH_TURN1", searchTurn1);
		mapSearch.put("SEARCH_TURN2", searchTurn2);
		mapSearch.put("SEARCH_SDATE", searchSDate);
		mapSearch.put("SEARCH_EDATE", searchEDate);
		mapSearch.put("SEARCH_HOSPS", vstrHosps);

		int amount = 10;
		int start = 0;
		int col = 0;
		int total = 0;
		int end = 0;
		String dir = (sdir == null || sdir.equals("asc")) ? "asc" : "desc";

		if (sStart != null)
		{ // 페이지 시작 번호
			try
			{
				start = Integer.parseInt(sStart);
			}
			catch (NumberFormatException e)
			{
				start = 0;
			}
			start = start > 0 ? start : 0;
		}
		if (sAmount != null)
		{ // 페이지 라인 수
			try
			{
				amount = Integer.parseInt(sAmount);
			}
			catch (NumberFormatException e)
			{
				amount = 0;
			}
			amount = (amount >= 10 || amount <= 100) ? amount : 10;
		}
		if (start < Integer.MAX_VALUE && amount < Integer.MAX_VALUE)
		{
			end = start + amount; //
		}

		if (sCol != null)
		{ // 검색 컬럼
			try
			{
				col = Integer.parseInt(sCol);
			}
			catch (NumberFormatException e)
			{
				col = 0;
			}
			col = (col >= 0 || col <= listColumns.size()) ? col : 0;
		}

		// 정렬 컬럼
		if (listColumns != null && listColumns.size() > col)
		{
			orderColName = listColumns.get(col);
		}

		if (start < Integer.MAX_VALUE)
		{
			mapSearch.put("start", start + 1);
		}
		mapSearch.put("end", end);
		mapSearch.put("orderColName", orderColName);
		mapSearch.put("dir", dir);
		return mapSearch;
	};
}
