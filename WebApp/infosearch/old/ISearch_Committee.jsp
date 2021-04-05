<!--
**      Program Name : ISearch_Committee.jsp
**      Program Date : 2004. 05.19.
**      Last    Date : 2004. 05.19.
**      Programmer   : Kim Kang Soo
**      Description  : 상세검색중 위원회홈페이지 검색
**
**      1)위원회별 리스트를 끌어오는 부분에서 DB커넥션을 사용함
-->
<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import=" java.util.*"%>
<%@ page import="com.verity.search.*" %>
<%@ page import="nads.dsdm.app.infosearch.common.IsSelectDelegate" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ include file="utils.jsp" %> 
<%@ page import="nads.lib.message.MessageBean"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%@ include file="/common/CheckSession.jsp" %>
<%@ page errorPage = "bad.jsp" %>
<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/System.css" rel="stylesheet" type="text/css">

<%
	IsSelectDelegate objCMD = new IsSelectDelegate();
	ArrayList objArrselectCommittee;		

	try {

		objArrselectCommittee = objCMD.selectCommittee("A000000003");
	
	} catch (AppException objAppEx) {
	
		// 에러 발생 메세지 페이지로 이동한다.
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
		System.out.println(objAppEx.getStrErrCode());
%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%	
		return;
	}


String realqueryText = "";
String deptText_last = "";
	//검색에 필요한 parameter 설정

//문자파라미터



	String ri = request.getParameter("ri"); 
	if(ri==null) ri = "";
	
	String SRCH_DISPLAY_KIND = (String)session.getAttribute("SRCH_DISPLAY_KIND");

	String SRCH_RECORD_CNT = (String)session.getAttribute("SRCH_RECORD_CNT");

	String query = StringUtil.getEmptyIfNull(request.getParameter("query")); 
	if(query==null) query = "";

	String queryText = StringUtil.getEmptyIfNull(request.getParameter("queryText")); 
	if(queryText==null) queryText = "";

	String deptText = StringUtil.getEmptyIfNull(request.getParameter("deptText")); 	
	if(deptText==null) deptText = "";


	String MENU_CD = StringUtil.getEmptyIfNull(request.getParameter("MENU_CD")); 	
	if(MENU_CD==null || MENU_CD.equals("")) MENU_CD = "02";

	String GROUPNAME = StringUtil.getEmptyIfNull(request.getParameter("GROUPNAME")); 	
	if(GROUPNAME==null) GROUPNAME = "";

//숫자파라미터

	int docStart = 1;
	if(request.getParameter("docStart")!=null)
		docStart = Integer.parseInt(request.getParameter("docStart"));
	
	int docPage = Integer.parseInt(SRCH_RECORD_CNT.trim());
	if(request.getParameter("docPage")!=null)
		docPage = Integer.parseInt(request.getParameter("docPage"));

	int     maxDocs     = 4000;
	if(request.getParameter("maxDocs") != null)
		maxDocs = Integer.parseInt(request.getParameter("maxDocs"));

	if (!deptText.equals("")) {

		deptText_last = toMulti(deptText)+"<IN>Z_GROUPCODE01";
		//out.println("<br><font color=red>1: deptText=위원회정보있는경우--deptText_last= "+deptText_last+"로 변경</font><br>");	
	}


	if (queryText.equals("")) {


		if (deptText.equals("")) {
			//out.println("<br><font color=red>2: deptText=위원회정보없는경우--위원회조건 queryText= "+queryText+"</font><br>");	
			realqueryText =toMulti(query);				
		} else {
			realqueryText =toMulti(deptText_last);	
			//out.println("<br><font color=red>3: deptText=위원회정보있는경우--위원회조건 queryText= "+queryText+"</font><br>");	
		}

	} else {

		if (deptText.equals("")) {
		//out.println("<br><font color=red>4:deptText.equals()</font><br>");	
			realqueryText =toMulti(query);	
		} else {
		//out.println("<br><font color=red>5:!deptText.equals()</font><br>");	
		//realqueryText =toMulti(deptText_last)+"<AND>"+toMulti(query);	
		realqueryText =toMulti(deptText_last)+"<AND>"+toMulti(queryText);			
		//queryText =toMulti(deptText);	
		}
	}



	Result result = null;
%>
<script language="JavaScript">
function GotoPage(form, docStart){	


	if(document.PageForm.query.value == '')
	{
	document.PageForm.action="./ISearch_Committee.jsp";		
	}
		var str1=document.PageForm.query.value

		for (var i=0; i < str1.length; i++) {
			if (str1.charAt(i) == "%" |str1.charAt(i) == ">" |str1.charAt(i) == "<" |str1.charAt(i) == ">" |str1.charAt(i) == "(" |str1.charAt(i) == ")" |str1.charAt(i) == "+" |str1.charAt(i) == "," |str1.charAt(i) == "[") {
			alert("허용되지않은 문자입니다.");
			document.PageForm.query.value="";			
			document.PageForm.query.focus();
			return ;
            }
         }

	form.docStart.value = docStart * form.docPage.value + 1;
	form.submit();
	return;
}

function GotoCommittee(form,deptText,deptText00,GROUPNAME,queryText){	

		var str1=document.PageForm.query.value

		for (var i=0; i < str1.length; i++) {
			if (str1.charAt(i) == "%" |str1.charAt(i) == ">" |str1.charAt(i) == "<" |str1.charAt(i) == ">" |str1.charAt(i) == "(" |str1.charAt(i) == ")" |str1.charAt(i) == "+" |str1.charAt(i) == "," |str1.charAt(i) == "[") {
			alert("허용되지않은 문자입니다.");
			document.PageForm.query.value="";			
			document.PageForm.query.focus();
			return ;
            }
         }

	if(document.PageForm.query.value == '')
	{
	document.PageForm.action="./ISearch_Committee.jsp";		
	}

	form.deptText.value = deptText;
	form.GROUPNAME.value = GROUPNAME;		
	form.queryText.value = queryText;		
	form.submit();
	return;
}


function search()
{

	var vQuery=""; //현재쿼리
	var vQueryText=""; //예전쿼리 + 현재쿼리

	vQueryText = document.PageForm.queryText.value;
	vQuery = document.PageForm.query.value;//검색창입력값


	if (document.PageForm.ri.checked) {
		if (vQueryText != "" && vQuery != "") {
			vQueryText = '(' + vQueryText + ')' + '<and>';
		}
		if (vQuery != "") {
			vQueryText = vQueryText + vQuery;
		}
	} else {
		vQueryText = vQuery;
	}

	if(document.PageForm.query.value == '')
	{
	document.PageForm.action="./ISearch_Committee.jsp";		
	}

		var str1=document.PageForm.query.value

		for (var i=0; i < str1.length; i++) {
			if (str1.charAt(i) == "%" |str1.charAt(i) == ">" |str1.charAt(i) == "<" |str1.charAt(i) == ">" |str1.charAt(i) == "(" |str1.charAt(i) == ")" |str1.charAt(i) == "+" |str1.charAt(i) == "," |str1.charAt(i) == "[") {
			alert("허용되지않은 문자입니다.");
			document.PageForm.query.value="";
			document.PageForm.query.focus();
			return ;
            }
         }
	
	document.PageForm.docStart.value = "1";
	document.PageForm.queryText.value = vQueryText;
	document.PageForm.submit();
}

function OnEnter()
{

	var vQuery=""; //현재쿼리
	var vQueryText=""; //예전쿼리 + 현재쿼리

	vQueryText = document.PageForm.queryText.value;
	vQuery = document.PageForm.query.value;//검색창입력값

<% if (query.equals("")) {}else{%>		
	if (document.PageForm.ri.checked) {
		if (vQueryText != "" && vQuery != "") {
			vQueryText = '(' + vQueryText + ')' + '<and>';
		}
		if (vQuery != "") {
			vQueryText = vQueryText + vQuery;
		}
	} else {
		vQueryText = vQuery;
	}
<%}%>
	if(document.PageForm.query.value == '')
	{
	document.PageForm.action="./ISearch_Committee.jsp";		
	}
		var str1=document.PageForm.query.value

		for (var i=0; i < str1.length; i++) {
			if (str1.charAt(i) == "%" |str1.charAt(i) == ">" |str1.charAt(i) == "<" |str1.charAt(i) == ">" |str1.charAt(i) == "(" |str1.charAt(i) == ")" |str1.charAt(i) == "+" |str1.charAt(i) == "," |str1.charAt(i) == "[") {
			alert("허용되지않은 문자입니다.");
			document.PageForm.query.value="";
			document.PageForm.query.focus();
			return false;
            }
         }

	document.PageForm.docStart.value = 1;
	document.PageForm.queryText.value = vQueryText;
	document.PageForm.submit();
}

</script>

</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
<%@ include file="/common/TopMenu.jsp" %>

<table width="100%" height="470" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="../image/common/bg_leftMenu.gif">
	<%@ include file="/common/LeftMenu.jsp" %></td>

    <td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr height="24" valign="top"> 
          <td height="24" colspan="2" align="left"><table width="789" height="24" border="0" cellpadding="0" cellspacing="0" bgcolor="FFF4DF">
              <tr>
                <td height="24"></td>
              </tr>
            </table></td>
        </tr>

<form  method=post name=PageForm action=./history/InsertUserHistoryProc.jsp >
        <tr valign="top"> 
          <td width="30" height="602" align="left"><img src="../image/common/bg_leftBody.gif" width="30" height="1"></td>
          <td align="left"><table width="759" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="23" colspan="2" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" colspan="2" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="20%" background="../image/infosearch/bg_infosearch_tit.gif"><span class="title">위원회 
                        홈페이지 검색</span> </td>
                      <td width="20%" align="left" background="../image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="60%" align="right" background="../image/common/bg_titLine.gif" class="text_s"><img src="../image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        Home&gt;정보검색&gt;<strong>위원회홈페이지검색</strong></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="50" colspan="2" align="left" class="text_s">각 위원회에서 관리하는 위원회 홈페이지에 등록된 게시판 자료를 웹로봇이 자동으로 수집하여 최근 자료순으로 제공해줍니다.(24시간 마다 자료  Update 됩니다.)</td>
              </tr>

              <tr> 
                <td height="15" colspan="2" align="left" valign="top" class="text_s">&nbsp;</td>
              </tr>

              <tr> 
                <td colspan="2" align="left" valign="top" class="text_s"><table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC">
                    <tr> 
                      <td height="63" align="center" bgcolor="#F3F3F3"><table width="51%" border="0" cellspacing="3" cellpadding="0">
                          <tr> 
                            <td width="17%" align="left"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                              <strong>검색어</strong></td>
                            <td width="68%" align="left"><strong> 
                              <input name="query" type="text" class="textfield" style="WIDTH: 250px" value="<%=toMulti(query)%>" maxlength=32 onKeyDown="JavaScript: if(event.keyCode == 13) {return OnEnter();};" >
                              </strong></td>
                            <td width="15%" align="left"><strong><a href="JavaScript:search();"><img src="../image/button/bt_gumsack_icon.gif" width="47" height="19" align="absmiddle" border=0></a></strong></td>
                          </tr>
                          <tr> 
                            <td align="left">&nbsp;</td>
                            <td align="left">
                            <input name="ri" type="checkbox"
                            <%if (!ri.equals("")) {%> checked <%}%>>결과내 재검색</td>
					<input type=hidden name=queryText value="<%=toMulti(queryText)%>">
					<input type=hidden name=deptText value="<%=toMulti(deptText)%>">	
					<input type=hidden name=maxDocs VALUE="<%=maxDocs%>">		
					<input type=hidden name=docStart VALUE="<%=docStart%>">
					<input type=hidden name=docPage VALUE="<%=docPage%>">
					<input type=hidden name=MENU_CD VALUE="<%=MENU_CD%>">
					<input type=hidden name=GROUPNAME VALUE="<%=GROUPNAME%>">								                              
                            <td align="left">&nbsp;</td>
                          </tr>
                        </table></td>
                    </tr>
                  </table></td>
              </tr>
              
              <tr> 
                <td height="20" colspan="2" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="30" align="left" valign="middle" class="soti_infosearch"><img src="../image/infosearch/icon_infosearch_soti.gif" width="9" height="9"> 
                  위원회별 검색 건수</td>
              </tr>
              <tr> 
                <td height="2" align="left" valign="top" class="td_infosearch"></td>
              </tr>
              <tr> 
                <td height="10" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="10" align="center" valign="top"><table width="719" border="0" cellspacing="0" cellpadding="0">

                    <tr> 
<%
	try {
		VSearch vs = new VSearch();
		
		//3.x 이상에만 있는 method
		

		vs.setServerSpec("10.201.60.2:9940");
		vs.setCharMap("ksc");
		vs.setUrlStringsMode(true);
		vs.addCollection("committee");
		vs.setMaxDocCount(1);				

		int phitCount = 0;
		String cnt_string="";
		int j=0; 
		for(int i=0; i < objArrselectCommittee.size(); i++){  
		Hashtable objHashBSorts = (Hashtable)objArrselectCommittee.get(i);
		j=i%4;

		if (query.equals("")) {
		cnt_string = objHashBSorts.get("GROUPCODE")+"<IN>Z_GROUPCODE01";
		}else{
		cnt_string = objHashBSorts.get("GROUPCODE")+"<IN>Z_GROUPCODE01<AND>"+toMulti(query);
		}
		//out.println("cnt_string=<br>"+toMulti(cnt_string)+"<br>");
		vs.setQueryText(toAscii(cnt_string));
		result = vs.getResult();	
		phitCount = result.docsFound;
%>


	<%	if (j==3){ %>
                      <td  height="22"><a href="JavaScript:GotoCommittee(document.PageForm,'<%=objHashBSorts.get("GROUPCODE")%>','','<%=objHashBSorts.get("GROUPNAME")%>','<%=query%>')"><%=objHashBSorts.get("GROUPNAME")%></a>(<%=phitCount%>)</td>
                    <tr> 
                    </tr>
	<%	}else{ %>
                      <td  height="22"><a href="JavaScript:GotoCommittee(document.PageForm,'<%=objHashBSorts.get("GROUPCODE")%>','','<%=objHashBSorts.get("GROUPNAME")%>','<%=query%>')"><%=objHashBSorts.get("GROUPNAME")%></a>(<%=phitCount%>)</td>
	<%}%>

<%	}

	} catch(Exception e) {
		System.out.println("ISearch_All01 : "+e.getMessage());
%>
	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
	}


	try {
		VSearch vs = new VSearch();
		
		//3.x 이상에만 있는 method
		

		vs.setServerSpec("10.201.60.2:9940");
		vs.setCharMap("ksc");
		vs.setUrlStringsMode(true);
		vs.addCollection("committee");
		
		vs.addField("VDKSUMMARY");
		vs.addField("VdkVgwKey");
		vs.addField("title");
		vs.addField("k2dockey");
		vs.addField("GROUPCODE00");
		vs.addField("GROUPCODE01");
		vs.addField("GROUPCODE02");
		vs.addField("GROUPNAME00");
		vs.addField("GROUPNAME01");
		vs.addField("GROUPNAME02");
		vs.addField("ATTACH");
		vs.addField("ATTACH_URL");
		vs.addField("GETDATE");
		vs.addField("REGDATE");

		

		vs.setMaxDocCount(maxDocs);
		vs.setSortSpec("REGDATE desc");
//		vs.setSortSpec("score desc");	
		vs.setDateFormat("${yyyy}-${mm}-${dd}");
		vs.setQueryText(toAscii(realqueryText));
		vs.setDocsStart(docStart);
		vs.setDocsCount(docPage);
		result = vs.getResult();	

	} catch(Exception e) {
		System.out.println("ISearch_All01 : "+e.getMessage());
%>
	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
	}
	
	//검색 결과 Print
	int hitCount = result.docsFound;

%>
                    </tr>

                  </table></td>
              </tr>
              <tr> 
                <td height="10" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="1" align="left" valign="top" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="20" colspan="2" align="left" valign="top">&nbsp;</td>
              </tr>
              <tr> 
                <td colspan="2" align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="30" align="left" valign="middle" class="soti_infosearch"><img src="../image/infosearch/icon_infosearch_soti.gif" width="9" height="9"> 
                  검색 결과<%if (!GROUPNAME.equals("")){out.println(" - "+GROUPNAME);}%></td>
              </tr>

                    <tr> 
                      <td width="59%" height="22" class="text_s"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        검색어 : <strong><%=replace(replace(toMulti(queryText), "<", "&lt;"),">","&gt")%></strong> (<%=hitCount%>개)</td>
                      <td width="41%" rowspan="2" align="right" valign="bottom" class="text_s"><table width="20%" border="0" cellspacing="0" cellpadding="0">
                          <tr align="left" valign="bottom"> 
                            <td><img src="../image/infosearch/tab_board.gif" width="97" height="23"></td>
                         
                          </tr>
                        </table></td>
                    </tr>
                  </table></td>
              </tr>
              <tr valign="top" height="2"> 
                <td height="2" colspan="2" align="left" valign="top" class="td_infosearch"></td>
              </tr>
              <tr valign="top" height="10"> 
                <td height="10" colspan="2" align="left" valign="top"></td>
              </tr>
              <tr valign="top"> 
                <td colspan="2" align="center" valign="top"><table width="719" border="0" cellspacing="0" cellpadding="0">

<%

	if (hitCount !=0) {
		String viewHref = "";
		Enumeration enum = result.documents().elements();
		while(enum.hasMoreElements()){
			Document doc = (Document)enum.nextElement();
%>
                    <tr> 
                      <td  height="22"><a href="<%=doc.field("url")%>"  <%if (SRCH_DISPLAY_KIND.trim().equals("0")) { out.println("target='_blank'");}%>><%=doc.rank%>. <font color="E4A644"><strong>[<%=doc.field("GROUPNAME01")%>><%=doc.field("GROUPNAME02")%>]</strong></font> 
                        <%=(doc.title)%><font color="9E9E9E">(<%=doc.field("REGDATE")%>)</font></a>

<%					if (!doc.field("ATTACH").equals("")) {

					    StringTokenizer tokenizer1 = new StringTokenizer(doc.field("ATTACH_URL"),",");
					    //out.println("Number of Tokens: "+tokenizer1.countTokens());
					    while(tokenizer1.hasMoreTokens()) {
					    //out.println("["+tokenizer1.nextToken()+"]");
					    String ahref=tokenizer1.nextToken();

%>      					
					<a href="<%=ahref%>" target='_blank'><%=ahref%></a>
<%				
					    }
					}
%>
                    </tr>
<%
		}
	}else{
%>
                    <tr> 
                      <td  align="center">검색된 결과가 없습니다.</td>
                    </tr>					                      
<%
	}
%>



                  </table></td>
              </tr>
              <tr valign="top" height="10"> 
                <td height="10" colspan="2" align="left" valign="top"></td>
              </tr>
              <tr valign="top" height="1"> 
                <td height="1" colspan="2" align="left" valign="top" class="tbl-line"></td>
              </tr>
              <tr valign="middle"> 
                <td height="35" colspan="2" align="center" valign="middle">
<!-- Page Navigation -->
<%
	if (hitCount > docPage) {
		int Total, Start, Page;
		int CurPage, StartPage, EndPage, TotalPage;
		int i;

		Total = hitCount; 
		if (hitCount > maxDocs) Total = maxDocs-1;
		Start = docStart;
		Page = docPage;

		CurPage = Start / Page;
		StartPage = ( Start / ( 10 * Page ) ) * 10;
		if((Total % Page)==0)
		{
		TotalPage = (Total / Page) -1;		
		}else{		
		TotalPage = Total / Page;
		}

		EndPage = StartPage + 9 > TotalPage ? TotalPage : StartPage + 9;

%>
<br>
<%

		if (StartPage != 0) {
			out.println("<a href=\'JavaScript:GotoPage(document.PageForm, 0)\'>[First]</a>&nbsp;");
			out.println("<a href=\'JavaScript:GotoPage(document.PageForm, " + (StartPage-10) + ")\'><img src='/image/button/bt_prev.gif' border='0'></a>&nbsp;");
		}
		

		for (i = StartPage ; i <= EndPage ; i++) {
			if( i == CurPage ){
				out.println("<strong>["+(i+1)+"]</strong>&nbsp;");;
			}
			else {
				out.println("<a href=\'JavaScript:GotoPage(document.PageForm, " + i + ")'>" +"["+ (i+1)+"]&nbsp;</a> ");
			}
		}

		if (TotalPage > EndPage) {
			EndPage = EndPage + 1;
			out.println("&nbsp;<a href=\'JavaScript:GotoPage(document.PageForm, " + EndPage + ")'><img src='/image/button/bt_next.gif' border='0'></a>");
			out.println("&nbsp;<a href=\'JavaScript:GotoPage(document.PageForm, " + TotalPage + ")'>[End]</a>");
		}
	}
%>                                </td>
              </tr>
              <tr> 
                <td height="3" align="left" valign="top" background="../image/common/line_table.gif"></td>
              </tr>
              <tr> 
                <td height="40" colspan="2" align="left"><a href="ISearch_Committee.jsp"><img src="../image/button/bt_goFirst.gif" width="67" height="20" border=0></a></td>
              </tr>
              <tr> 
                <td height="15" colspan="2" align="left" valign="top">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
</table>
<%@ include file="../common/Bottom.jsp" %>
</form>
</body>
</html>
