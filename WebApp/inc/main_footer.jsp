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
	ArrayList objCommittArry = new ArrayList();//����ȸ
	Hashtable objUserCommittHt = new Hashtable();
	Hashtable objCommittHt = new Hashtable();

    ArrayList objRelOrganArry = new ArrayList();//���ñ��
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
        window.open(url, "��ȸ�����ý���");
    }
    function fun_chgcomm(){
        var url = document.getElementById("committee").value;
        window.open(url, "����ȸȨ������");
    }
    function fun_relorgan(){
        var url = document.getElementById("relorgan").value;
        window.open(url, "���ñ��Ȩ������");
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
                    <!-- 2015-04-23 ���� ��
                    <a href="javascript:fun_bottomhomepage('http://org.mospa.go.kr/org/external/chart/index.jsp?code=8888880&a=1&b=3&str=&d=0&e=0&menuGbn=','����������');">
                     -->
                     <!-- 2015-04-23 ���� �� -->
                     <a href="javascript:fun_bottomhomepage('http://www1.president.go.kr/cheongwadae/organization/government.php','����������');">
                     <img src="/images2/common/f_banner01.gif" alt="����������" width="81" height="24"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a><img src="/images2/common/f_line.gif" width="1" height="24" /><a href="javascript:fun_bottomhomepage('/reqsubmit/70_organchargesh/SearchRelOrgan.jsp?InOutMode=I','��ȸ������ȸ');"><img src="/images2/common/f_banner02.gif" alt="��ȸ������ȸ" width="110" height="24" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a><img src="/images2/common/f_line.gif" width="1" height="24"/><a href="javascript:fun_bottomhomepage('/reqsubmit/70_organchargesh/SearchOutRelOrgan.jsp?InOutMode=X','����������ȸ');"><img src="/images2/common/f_banner03.gif" width="107" height="24" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" alt="��������"/></a>
                </li>
                <li class="site"><img src="/images2/common/f_site_tl.gif" width="66" height="25" /><!-- ������ ���� �ٿ��ּ���-->
                    <select name="committee" id="committee" class="selectBox" style="width:160px;" onchange="fun_chgcomm()">
                        <option value="GI00006426" selected>::: ����ȸȨ������</option>
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
        if (strOrganNmLeft.equals("��ȸ�����ȸ")){
            url = "http://steering.na.go.kr";
        } else if (strOrganNmLeft.equals("�����������ȸ")){
            url ="http://legislation.na.go.kr";
        } else if (strOrganNmLeft.equals("�����������ȸ")){
            url ="http://legislation.na.go.kr";
        } else if (strOrganNmLeft.equals("��������ȸ")){
            url ="http://policy.na.go.kr";
        } else if (strOrganNmLeft.equals("��ȹ��������ȸ")){
            url = "http://finance.na.go.kr";
        } else if (strOrganNmLeft.equals("�ܱ������������ȸ")){
            url = "http://uft.na.go.kr";
        } else if (strOrganNmLeft.equals("��������ȸ")){
            url = "http://defense.na.go.kr";
        } else if (strOrganNmLeft.equals("������������ȸ")){
            url = "http://adminhom.na.go.kr";
        } else if (strOrganNmLeft.equals("�������б������ȸ")){
            url = "http://edusnt.na.go.kr";
        } else if (strOrganNmLeft.equals("��ȭü����������������ȸ")){
            url = "http://culture.na.go.kr";
        } else if (strOrganNmLeft.equals("�󸲼����ǰ����ȸ")){
            url = "http://agri.na.go.kr";
        } else if (strOrganNmLeft.equals("���İ�������ȸ")){
            url = "http://k-economy.na.go.kr";
        } else if (strOrganNmLeft.equals("���Ǻ�������ȸ")){
            url = "http://health.na.go.kr";
        } else if (strOrganNmLeft.equals("ȯ��뵿����ȸ")){
            url = "http://environment.na.go.kr";
        } else if (strOrganNmLeft.equals("�����ؾ�����ȸ")){
            url = "http://ltmc.na.go.kr";
        } else if (strOrganNmLeft.equals("��������ȸ")){
            url = "http://intelligence.na.go.kr";
        } else if (strOrganNmLeft.equals("������������ȸ")){
            url = "http://women.na.go.kr";
        } else if (strOrganNmLeft.equals("������Ư������ȸ")){
            url = "http://budget.na.go.kr";
        } else if (strOrganNmLeft.equals("����Ư������ȸ")){
            url = "http://moral.na.go.kr";
        } else if (strOrganNmLeft.equals("Ư������ȸ")){
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
                    </select><!-- ������ ���� �ٿ��ּ���--><select name="relorgan" id="relorgan" class="selectBox" style="width:150px;" onchange="fun_relorgan()">
                    <option value="">::: ���ñ�� Ȩ������</option>
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
                    </select><!-- ������ ���� �ٿ��ּ���--><select name="systemhomepage" id="systemhomepage" class="selectBox" style="width:150px;" onchange="fun_systemhomepage()">
                        <option value="#">::: ��ȸ�����ý���</option>
                          <option value="http://likms.assembly.go.kr">�Թ��������İ����ý���</option>
                          <option value="http://likms.assembly.go.kr/law/jsp/law/Main.jsp">�������������ý���</option>
                          <option value="http://likms.assembly.go.kr/record/index.html">ȸ�ǷϽý���</option>
                          <option value="http://w3.assembly.go.kr/vod/index.jsp?param=">����ȸ�ǷϽý���</option>
                          <option value="http://likms.assembly.go.kr/bill">�Ǿ������ý���</option>
                          <option value="http://w3.assembly.go.kr/multimedia/index.jsp?param=">�̵���ڷ��</option>
                          <option value="http://likms.assembly.go.kr/inspections">�������������ý���</option>
                          <option value="http://likms.assembly.go.kr/bill/nafs/nafsList.do">����������ý���</option>
                          <option value="http://www.assembly.go.kr/renew10/cmn/ipmang_pop.jsp">���ͳ��ǻ��߰�ý���</option>
                          <option value="0">--------------</option>
                          <option value="http://committee.na.go.kr/intro.html">��ȸ��������ȸ��Ư������ȸ</option>
                          <option value="http://nas.na.go.kr">��ȸ�繫ó</option>
                          <option value="http://www.nanet.go.kr/main.jsp">��ȸ������</option>
                          <option value="http://www.nabo.go.kr/">��ȸ������åó</option>
                          <option value="http://www.nars.go.kr/">��ȸ�Թ�����ó</option>
                    </select>
                </li>
            </ul>
        </div>
        <p><a href="javascript:MM_openBrWindow3('http://naps.assembly.go.kr/persnalinfo.htm','','width=600,height=520')"><img src="/images2/login/movie_04_con4.gif"/></a><img src="/images2/common/copyright.gif" width="455" height="26" alt="����� �������� �ǻ��� 1(���ǵ���). Copyright (C) ���ѹα���ȸ. All Right Reserved." /></p>
    </div>
</form>
