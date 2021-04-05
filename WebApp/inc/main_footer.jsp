<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="nads.lib.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%
	ArrayList objCommittArry = new ArrayList();//위원회
	Hashtable objUserCommittHt = new Hashtable();
	Hashtable objCommittHt = new Hashtable();

    ArrayList objRelOrganArry = new ArrayList();//관련기관
	Hashtable objRelOrganHt = new Hashtable();

	String strUserCommitt = "";
    String strUserId = objUserInfo.getUserID();
    String strCommittee = kr.co.kcc.bf.bfutil.StringUtil.getNVL(request.getParameter("comm"), "");
	try{
		nads.dsdm.app.main.MainDelegate objMainCommDelegate = new nads.dsdm.app.main.MainDelegate();
		Hashtable objResultHt = objMainCommDelegate.selectUserCommittee(strUserId) ;

		objCommittArry = (ArrayList)objResultHt.get("COMM");
		objUserCommittHt = (Hashtable)objResultHt.get("USERCOMM");
		if(objUserCommittHt != null){
			strUserCommitt = (String)objUserCommittHt.get("REL_ORGAN_ID");
		}
		if(strCommittee.equals("") && objCommittArry.size() > 0){
			objCommittHt = (Hashtable)objCommittArry.get(0);
			strCommittee = (String)objCommittHt.get("ORGAN_ID");
			if (strUserCommitt != null && !strUserCommitt.equals("")){
				strCommittee = strUserCommitt;
			}
		}

        objRelOrganArry = objMainCommDelegate.selectRelOrgan(strCommittee, "");

	} catch (AppException objAppEx) {

		objMsgBean.setMsgType(objMsgBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
    }
%>
<script language="javascript">

    function fun_bottomhomepage(strUrl, strNm){

        window.open(strUrl, strNm);

    }
    function fun_systemhomepage(){
        var url = document.getElementById("systemhomepage").value;
        window.open(url, "국회정보시스템");
    }
    function fun_chgcomm(){
        var url = document.getElementById("committee").value;
        window.open(url, "위원회홈페이지");
    }
    function fun_relorgan(){
        var url = document.getElementById("relorgan").value;
        window.open(url, "관련기관홈페이지");
    }
	function MM_openBrWindow3(theURL,winName,features)
	{
		var winl = (screen.width - 900) / 2;
		var wint = (screen.height - 920) / 2;
		var winProp='width=900,height=920,scrollbars=yes, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no,top=' + wint + ',left=' + winl;
		window.open(theURL, winName, winProp);
	}
</script>
<form name="form_main1" method="post">
    <div id="footer">
        <div id="footer_link">
            <ul>
                <li class="banner">
                    <!-- 2015-04-23 수정 전
                    <a href="javascript:fun_bottomhomepage('http://org.mospa.go.kr/org/external/chart/index.jsp?code=8888880&a=1&b=3&str=&d=0&e=0&menuGbn=','정부조직도');">
                     -->
                     <!-- 2015-04-23 수정 후 -->
                     <a href="javascript:fun_bottomhomepage('http://www1.president.go.kr/cheongwadae/organization/government.php','정부조직도');">
                     <img src="/images2/common/f_banner01.gif" alt="정부조직도" width="81" height="24"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a><img src="/images2/common/f_line.gif" width="1" height="24" /><a href="javascript:fun_bottomhomepage('/reqsubmit/70_organchargesh/SearchRelOrgan.jsp?InOutMode=I','국회직원조회');"><img src="/images2/common/f_banner02.gif" alt="국회직원조회" width="110" height="24" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a><img src="/images2/common/f_line.gif" width="1" height="24"/><a href="javascript:fun_bottomhomepage('/reqsubmit/70_organchargesh/SearchOutRelOrgan.jsp?InOutMode=X','기관담당자조회');"><img src="/images2/common/f_banner03.gif" width="107" height="24" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" alt="기관담당자"/></a>
                </li>
                <li class="site"><img src="/images2/common/f_site_tl.gif" width="66" height="25" /><!-- 공간을 위해 붙여주세요-->
                    <select name="committee" id="committee" class="selectBox" style="width:160px;" onchange="fun_chgcomm()">
                        <option value="GI00006426" selected>::: 위원회홈페이지</option>
<%
	String strOrganIdLeft = "";
	String strOrganNmLeft = "";
	String strHomeUrl = "";
	String strSelected = "";
	int iSelectedChk = 0;
	for(int i=0; i<objCommittArry.size(); i++){
		objCommittHt = (Hashtable)objCommittArry.get(i);
		strOrganIdLeft = (String)objCommittHt.get("ORGAN_ID");
		strOrganNmLeft = (String)objCommittHt.get("ORGAN_NM");
		strHomeUrl = (String)objCommittHt.get("HOME_URL");
		if(strOrganIdLeft.equals(strCommittee)){
			strSelected = "selected";
			iSelectedChk = 1;
		}else{
			strSelected = "";
		}
        String url = "";
        if (strOrganNmLeft.equals("국회운영위원회")){
            url = "http://steering.na.go.kr";
        } else if (strOrganNmLeft.equals("법제사법위원회")){
            url ="http://legislation.na.go.kr";
        } else if (strOrganNmLeft.equals("법제사법위원회")){
            url ="http://legislation.na.go.kr";
        } else if (strOrganNmLeft.equals("정무위원회")){
            url ="http://policy.na.go.kr";
        } else if (strOrganNmLeft.equals("기획재정위원회")){
            url = "http://finance.na.go.kr";
        } else if (strOrganNmLeft.equals("외교통상통일위원회")){
            url = "http://uft.na.go.kr";
        } else if (strOrganNmLeft.equals("국방위원회")){
            url = "http://defense.na.go.kr";
        } else if (strOrganNmLeft.equals("행정안전위원회")){
            url = "http://adminhom.na.go.kr";
        } else if (strOrganNmLeft.equals("교육과학기술위원회")){
            url = "http://edusnt.na.go.kr";
        } else if (strOrganNmLeft.equals("문화체육관광방송통신위원회")){
            url = "http://culture.na.go.kr";
        } else if (strOrganNmLeft.equals("농림수산식품위원회")){
            url = "http://agri.na.go.kr";
        } else if (strOrganNmLeft.equals("지식경제위원회")){
            url = "http://k-economy.na.go.kr";
        } else if (strOrganNmLeft.equals("보건복지위원회")){
            url = "http://health.na.go.kr";
        } else if (strOrganNmLeft.equals("환경노동위원회")){
            url = "http://environment.na.go.kr";
        } else if (strOrganNmLeft.equals("국토해양위원회")){
            url = "http://ltmc.na.go.kr";
        } else if (strOrganNmLeft.equals("정보위원회")){
            url = "http://intelligence.na.go.kr";
        } else if (strOrganNmLeft.equals("여성가족위원회")){
            url = "http://women.na.go.kr";
        } else if (strOrganNmLeft.equals("예산결산특별위원회")){
            url = "http://budget.na.go.kr";
        } else if (strOrganNmLeft.equals("윤리특별위원회")){
            url = "http://moral.na.go.kr";
        } else if (strOrganNmLeft.equals("특별위원회")){
            url = "http://special.na.go.kr";
        }
        if (!url.equals("")){
%>
            <option value="<%=url%>" <%=strSelected%>><%=strOrganNmLeft%></option>
<%
        }
	}
%>
                        </select></td>
<%
	if (iSelectedChk == 0){
%>
<script>
  var committee = document.getElementById("committee");
  committee.selectedIndex = 0;
</script>
<%
	}
%>
                    </select><!-- 공간을 위해 붙여주세요--><select name="relorgan" id="relorgan" class="selectBox" style="width:150px;" onchange="fun_relorgan()">
                    <option value="">::: 관련기관 홈페이지</option>
<%

	for(int j=0; j<objRelOrganArry.size(); j++){
		objRelOrganHt = (Hashtable)objRelOrganArry.get(j);
		strOrganIdLeft = (String)objRelOrganHt.get("ORGAN_ID");
		strOrganNmLeft = (String)objRelOrganHt.get("ORGAN_NM");
		strHomeUrl = (String)objRelOrganHt.get("HOME_URL");
        if (strHomeUrl.equals("http://nas.assembly.go.kr")){
            strHomeUrl = "http://nas.na.go.kr";
        }
%>
    <option value="<%=strHomeUrl%>" <%=strSelected%>><%=strOrganNmLeft%></option>
<%
	}
%>
                    </select><!-- 공간을 위해 붙여주세요--><select name="systemhomepage" id="systemhomepage" class="selectBox" style="width:150px;" onchange="fun_systemhomepage()">
                        <option value="#">::: 국회정보시스템</option>
                          <option value="http://likms.assembly.go.kr">입법통합지식관리시스템</option>
                          <option value="http://likms.assembly.go.kr/law/jsp/law/Main.jsp">법률지식정보시스템</option>
                          <option value="http://likms.assembly.go.kr/record/index.html">회의록시스템</option>
                          <option value="http://w3.assembly.go.kr/vod/index.jsp?param=">영상회의록시스템</option>
                          <option value="http://likms.assembly.go.kr/bill">의안정보시스템</option>
                          <option value="http://w3.assembly.go.kr/multimedia/index.jsp?param=">미디어자료관</option>
                          <option value="http://likms.assembly.go.kr/inspections">국정감사정보시스템</option>
                          <option value="http://likms.assembly.go.kr/bill/nafs/nafsList.do">예결산정보시스템</option>
                          <option value="http://www.assembly.go.kr/renew10/cmn/ipmang_pop.jsp">인터넷의사중계시스템</option>
                          <option value="0">--------------</option>
                          <option value="http://committee.na.go.kr/intro.html">국회상임위원회및특별위원회</option>
                          <option value="http://nas.na.go.kr">국회사무처</option>
                          <option value="http://www.nanet.go.kr/main.jsp">국회도서관</option>
                          <option value="http://www.nabo.go.kr/">국회예산정책처</option>
                          <option value="http://www.nars.go.kr/">국회입법조사처</option>
                    </select>
                </li>
            </ul>
        </div>
        <p><a href="javascript:MM_openBrWindow3('http://naps.assembly.go.kr/persnalinfo.htm','','width=600,height=520')"><img src="/images2/login/movie_04_con4.gif"/></a><img src="/images2/common/copyright.gif" width="455" height="26" alt="서울시 영등포구 의사당로 1(여의도동). Copyright (C) 대한민국국회. All Right Reserved." /></p>
    </div>
</form>
