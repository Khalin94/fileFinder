<%@ page contentType="text/html;charset=euc-kr" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.*" %>
<%@ page import="nads.dsdm.app.join.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ksign.jce.util.*"%>
<%@ page import="ksign.jce.sample.*"%>

<%
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Pragma","no-cache"); 
	response.setDateHeader("Expires",0);


	//String in_symm_enckey = "";
	String in_eventdate = "";
	String in_username = "";

	byte[] bt_eventdate = null;
	byte[] bt_username = null;


	String strUserInGrpId = ""; 
	String strUserOutGrpId = ""; 
	String strSrchRecordCnt = ""; 
	String strSrchDisplayKind = "";
	String strGtherPeriod = "";
	String strReqSubmtFlag = "";
	String strJuminNoTemp = "";
	String ORGAN_NM = "";
	String ORGAN_NO = "";
	String HOME_URL = "";
	String ORGAN_JUSO1 = "";
	String ORGAN_JUSO2 = "";
	String eventdate = "";
	String username = "";
	String organid = "";

	
	
	ArrayList objChargeInfoArry = new ArrayList();
	Hashtable objorgandata = null;

System.out.println("RegistUserInfoInPut.jsp Start~~~~~~~~~~");
	//EncData = ((String)java.net.URLDecoder.decode(request.getParameter("issacweb_data"),"KSC5601")).replaceAll(" ","+");
//	in_symm_enckey = request.getParameter("symm_enckey");
	in_eventdate = request.getParameter("eventdate");
	in_username = request.getParameter("username");

	String strOrganID 	= StringUtil.getNVLNULL(request.getParameter("ORGAN_ID")).trim();
	String strSFlag 	= StringUtil.getNVLNULL(request.getParameter("SFLAG")).trim();
	ResultSetSingleHelper objRS = null;
	
	
/*	
	if (in_symm_enckey != null){
		System.out.println("ksign");
		///////////////////////////////////////////////////// START

		System.out.println("��ȣȭ�� Ű��  : " + in_symm_enckey );
		System.out.println("------------------------------------------------------------------------------<BR>");

		JCEUtil.initProvider();
		try {

			AsymmDecrypt asymmDecryt = new AsymmDecrypt();
			SymmDecrypt symmdecrypt = new SymmDecrypt();
  
			//������ ����
			//���� ������ ��� ������ ��� �Ʒ� ó�� , LDAP�� ��� �ش� LDAP�� 
			//�ش��ϴ� ��ȣ�ϰ�
			//������������ Ű��
			String priPath = "/usr/libgpkiapi_jni";
			String passwd = "dlswmdrhksfl11!";	
			String sendKey = "SVR9710000001_env.key"; //���������� Ű��  
			String licPath = "/usr/libgpkiapi_jni/conf";

			//���ĪŰ ��ȣȭ
			//�Ķ���ͷδ� (��ȣȭ ��, ������ �н�����, ������ ��� �Ǵ� LDAP, ������������ Ű)
			String key = asymmDecryt.AsymmDecrypt(in_symm_enckey, passwd, priPath, sendKey, licPath);

			if(key == null){
				System.out.println("���� �޽��� : " + JCEUtil.getErrormsg());
				System.out.println("���� �ڵ� : " + JCEUtil.getErrorcode());
			}

			//��ȣȭ�� ������ �������� ��ȣȭ
			//�Ķ���ͷδ�(��ȣȭ�� ��, )
			//byte[] bt_regsid1 = symmdecrypt.SymmDecrypt(in_regsid1, key, "SEED");//����Ű�� ���� ��ȣȭ
			//byte[] bt_regsid2 = symmdecrypt.SymmDecrypt(in_regsid2, key, "SEED");

			bt_eventdate = symmdecrypt.SymmDecrypt(in_eventdate, key, "SEED");

			bt_username = symmdecrypt.SymmDecrypt(in_username, key, "SEED");


			eventdate = new String(bt_eventdate);
			username = new String(bt_username);

			System.out.println("������ Ű�� : " + key );

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e.toString());
			System.out.println("error1 :  " + e.toString());
			System.out.println("error2 : " + JCEUtil.getErrormsg());
			System.out.println("error3 : " + JCEUtil.getErrorcode());
		}
		
		//System.out.println( request.getParameter("_E2E_SAFEON_regsid1") );
		//System.out.println( request.getParameter("_E2E_SAFEON_regsid2") );
		//System.out.println( "safeon1 : " + regsid1 ); 
		//System.out.println( ",safeon2 : " + regsid2 ); 
		//����Ű���� safeon ��ȣ ��		

	}
*/


		
		

		nads.dsdm.app.activity.userinfo.UserInfoDelegate objUserInfoDelegate = new nads.dsdm.app.activity.userinfo.UserInfoDelegate();
		try
		{			
			objChargeInfoArry = objUserInfoDelegate.selectChargeCdInfo();
			
			Config objConfig = PropertyConfig.getInstance();
			strUserInGrpId = objConfig.get("join.userInGrpId");
			strUserOutGrpId = objConfig.get("join.userOutGrpId");
			strSrchRecordCnt = objConfig.get("join.srchRecordCnt");  
			strSrchDisplayKind = objConfig.get("join.srchDisplayKind");
			strGtherPeriod = objConfig.get("join.gtherPeriod");  
			strReqSubmtFlag = objConfig.get("join.reqSubmtFlag4Submit"); 

			JoinMemberDelegate  objOrgan = new JoinMemberDelegate();
						
			if(!strOrganID.equals("")){
				objRS = new ResultSetSingleHelper(objOrgan.getOrganInfo(strOrganID));
				ORGAN_NM = (String)objRS.getObject("ORGAN_NM");
				ORGAN_NO = (String)objRS.getObject("ORGAN_NO");
				HOME_URL = (String)objRS.getObject("HOME_URL");
				ORGAN_JUSO1 = (String)objRS.getObject("JUSO1");
				ORGAN_JUSO2 = (String)objRS.getObject("JUSO2");
			}	
		}
		catch(AppException objAppEx)
		{	
			
	%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
	<%  	
			return;
		}			
	

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>�����ڷ���������ý���</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta http-equiv="Page-Enter" content="blendTrans(Duration=.01)" />
<meta http-equiv="Page-Exit" content="blendTrans(Duration=.01)" />
<script type="text/javascript" src="/js2/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/js2/jquery.selectbox-0.6.1.js"></script>
<script type="text/javascript" src="/js2/common.js"></script>
<link type="text/css" href="/css2/style.css" rel="stylesheet">
<script src="/js/common.js"></script>
<script src="/js/validate.js" ></script>
<script src="/js/activity.js"></script>
<!-- �����ȣ ������ ����  -->
<script type="text/javascript" src="/zipinfo/js/jquery-1.8.3.min.js"></script>
<script language="javascript">
var winBG;
function fun_view(frm) {
		var img;

		if(img == "")
		{
			alert("���õ� ������ �����ϴ�.");
			return;
		}

		if(img != ""){
			var vafile = frm.selFile.value.substr(frm.selFile.value.length - 4, frm.selFile.value.length);
			
			if((vafile.toLowerCase() != ".gif") && (vafile.toLowerCase() != ".jpg") &&
			   (vafile.toLowerCase() != ".bmp") && (vafile.toLowerCase() != ".jpeg")){
				alert("���������� Ȯ����� .gif, .jpg .jpeg .bmp �� ����� �� �ֽ��ϴ�." + vafile);
				return;
			}	
		} 
				
		img=frm.selFile.value;
		img=img.replace(/:/, "|");
		img=img.replace(/\\/gi, "/");
		img="file:///"+img;

		if ((winBG==null)||(winBG.closed==true)) {
			winBG=window.open("", "", "width=220,height=200,resizable=1");
		}
		winBG.document.open();
		winBG.document.write("<html>");
		winBG.document.write("<head></head>");
		winBG.document.write("<body>");
		winBG.document.write("<table width='205' border='0' cellspacing='0' cellpadding='0'>");
		winBG.document.write("<tr>");
		winBG.document.write("<td align='center'><img src='" +  img + "' width='200' height='160'></td>");
		winBG.document.write("</tr>");
		winBG.document.write("<tr>");
		winBG.document.write("<td height='10' class='tbl-line'></td>");
		winBG.document.write("</tr>");
		winBG.document.write("<tr>");
		winBG.document.write("<td align='center'><a href='javascript:self.close()'><img src='/image/button/bt_close.gif' width='46' height='11' border='0'></a></td>");
		winBG.document.write("</tr>");
		winBG.document.write("</body>");
		winBG.document.write("</html>");
		winBG.document.close();
		winBG.window.focus();
	}



	function fun_check(varObj){
		var varCheck ='';
		if(varObj.checked == true){
			
			varCheck = 'document.frmPreJoinMember.s' + varObj.name.substring(1, varObj.name.length)
			                      + '.disabled = true';
		}else{
			varCheck = 'document.frmPreJoinMember.s' + varObj.name.substring(1, varObj.name.length)
			                      + '.disabled = false';
			
		}
		eval(varCheck);		 
	}
	
	function fun_checkm(varObj){
		var varCheck ='';
		if(varObj.checked == true){
			varCheck = 'document.frmPreJoinMember.m' + varObj.name.substring(1, varObj.name.length)
			                      + '.disabled = true';
		}else{
			varCheck = 'document.frmPreJoinMember.m' + varObj.name.substring(1, varObj.name.length)
			                      + '.disabled = false';
			
		}
		eval(varCheck);		 
	}

function makeTextBox_OLD(chbox,divNm)
{
 eval(divNm).innerHTML = "";

 if(chbox.checked == true)
	eval(divNm).innerHTML = "<input type='text' name='"+divNm+"' class='textfield' style='WIDTH: 200px' maxlength=15 >";
 else
	 eval(divNm).innerHTML=" ";
 

}

function makeTextBox(chbox,divNm)
{
 
	 var txtbox = " ";

	 if(chbox.checked == true)
	{
		eval(divNm).innerHTML = txtbox+ "<input type='text' name='"+divNm+"' class='textfield' style='WIDTH: 200px' maxlength=15 >";
	 }
	 else
	{
		 eval(divNm).innerHTML=txtbox+"";
	}

}


function checkUserCharge(frm){

//�������� �ݵ�� �����ؾ� ��(�������� �ܺλ���ڸ� ����)

		
		
		var varCheck = 0;
		var varCnt = 0;
		for(var i=0; i < frm.elements.length; i++){
			if(frm.elements[i].name.substring(0,4)=='mchr'){
				varCnt = parseInt(varCnt + 1);
				if(frm.elements[i].checked == true){
					varCheck = 1;
					break;
				}
			}
			if(frm.elements[i].name.substring(0,4)=='schr'){
				varCnt = parseInt(varCnt + 1);
				if(frm.elements[i].checked == true){
					varCheck = 1;
					break;
				}
			}
		}
		
        if(checkValidation(frm)){

			if((varCnt > 0) && (varCheck == 0)){
				alert("�������� �ݵ�� �־�� �մϴ�.");
				return false;		
			}else
				frm.submit();
				return true;
		}else
			return false;



}

function openWindow(url, name, width, height, scroll)   {
    var top  = screen.height / 2 - height / 2 - 50;
    var left = screen.width / 2 - width / 2 ;
    var scrollbars = "auto";

    if(scrollbars != null) {
    	scrollbars = scroll;
    }

    var win =
        open(url,
            name,
            'width=' + width + ', height=' + height + ', top=' + top +
            ', left=' + left + ', resizable=no, status=yes, toolbar=no, menubar=no, resizable, scrollbars=' + scrollbars);
    win.focus();
    return win;
}


function wincall() {
		
	openWindow('/zipinfo/roadSearchAddress.html', 'search', '500', '573', 'N');
	return false;
}
  function _callbackZipCode(data) {
	  $("#POST_CD").val(data.zipcode);
	  $("#POST_CD1").val(data.zipcode);
	  $("#JUSO1").val(data.addr);	  
}
  
</script>
<script Language="Javascript">
//�����ʸ��콺 Ŭ������
function clickIE() {
if (document.all) {
return false;
}
} 
function clickNS(e) {
if (document.layers||(document.getElementById&&!document.all)) { 
if (e.which==2||e.which==3) {
return false;
}
}
} 
if (document.layers) {
document.captureEvents(Event.MOUSEDOWN);
document.onmousedown=clickNS;
} 
else{
document.onmouseup=clickNS;
document.oncontextmenu=clickIE;
} 
document.oncontextmenu=new Function("return false") 
</script>

<!--[if lt IE 7]>
<link rel="stylesheet" type="text/css" href="/css2/ie6.css" media="screen" />
<![endif]-->
<!--[if IE 7]>
<link rel="stylesheet" type="text/css" href="/css2/ie7.css" media="screen" />
<![endif]-->
<style>
#log_wrap {
	width:100%;
	height:100%;
}

.login {
	width:745px;
	overflow:hidden;
	margin-top:3%;
	margin-left:22%;
}

.login h1 {
	width:685px;
	overflow:hidden;
}

.user_con {
}

#log_footer {
	width:100%;
	overflow:hidden;
	margin-top:10px;
	margin-bottom:20px; 
}

#log_footer .copy {
	display:block;
	width:100%;
	padding-left:30%;
	border-top:#ccc solid 1px;
	padding-top:10px;
}
</style>
</head>

<body onload="init();">
<div id="log_wrap">
    <div class="login">
        <h1><img src="/images2/login/logo02.gif" width="194" height="46" /></h1>
        <div class="user_con"> <br />
            <br />
            <!-- list --> 
			<form action="/join/RegistUserInfoInPutProc.jsp" method="post" name="frmPreJoinMember" encType="multipart/form-data" onsubmit="return checkUserCharge(document.frmPreJoinMember)">
            <span class="list02_tl">����� ���� �Է�</span> <span class="list_total">(*) ǥ�ô� �ʼ� �׸� �Դϴ�.</span>
            <table border="0" cellspacing="0" cellpadding="0" class="list03" >
                <tr>
                    <th width="18%" rowspan="3" align="middle" valign="top"><img src="/images2/foundation/pic.gif" width="110" height="120" class="pic" /></th>
                    <th width="85" align="middle">����<span class="warning">*</span></th>
                    <td ><%=in_username%><input name="USER_NM" type="hidden" value="<%=in_username%>"></td>
                </tr>				
                <tr>
                    <th align="middle">�������</th>
                    <td height="25">										
					<input type=hidden name="eventdate" value="<%=in_eventdate%>">
					<%=in_eventdate.substring(0,4)%>��&nbsp;<%=in_eventdate.substring(4,6)%>��&nbsp;<%=in_eventdate.substring(6,8)%>��
					</td>
                </tr>                
                <tr>
                    <th align="middle">�����<span class="warning">*</span></th>
                    <td height="25"><input name="ORGAN_NM" value="<%=ORGAN_NM%>" type="text" class="textfield" style="WIDTH: 220px" readonly / b /> 
					<input name="ORGAN_ID" type="hidden" value="<%=strOrganID%>" > 
					<input name="ORGAN_NO" type="hidden" value="<%=ORGAN_NO%>"> 
					<input name="HOME_URL" type="hidden" value="<%=HOME_URL%>"> 
					<input name="ORGAN_JUSO1" type="hidden" value="<%=ORGAN_JUSO1%>"> 
					<input name="ORGAN_JUSO2" type="hidden" value="<%=ORGAN_JUSO2%>">
					<img src="/image/button/bt_search_icon.gif" width="47" height="19" style="cursor:hand" align="absmiddle" onclick="winopen('/join/SearchOrgPop.jsp','SearchOrgPop','height=400,width=520,scrollbars=yes,resize=yes')">
					</td>
                </tr>
                <tr>
                    <th colspan="2" align="middle" valign="top">�μ���<span class="warning">*</span></th>
                    <td height="25"><input name="DEPT_NM" style="width:120px;" / b /></td>
                </tr>
                <tr>
                    <th colspan="2" align="middle" valign="top">������</th>
                    <td height="25"><input name="POSI_NM" style="width:120px;" / b /></td>
                </tr>
                <tr>
                    <th colspan="2" align="middle" valign="top">���޸�</th>
                    <td height="25"><input name="GRD_NM" style="width:120px;" / b /></td>
                </tr>
                <tr>
                    <th colspan="2" align="middle" valign="top">e-mail<span class="warning">*</span></th>
                    <td height="25"><input maxlength="30" name="EMAIL"  style="width:250px;"/></td>
                </tr>
                <tr>
                    <th rowspan="3" align="middle" >��ȭ��ȣ</th>
					<input type=hidden name="OFFICE_TEL" >
                    <th height="25" class="fonts" >�繫��<span class="warning">*</span></th>
                    <td height="25" colspan="2"><input maxlength="4" name="OFFICE_TEL1" style="width:30px;text-align:right;padding:1px" / b />
                        -
                        <input maxlength="4" name="OFFICE_TEL2" style="width:30px;text-align:right;padding:1px"/ b />
                        -
                        <input maxlength="4" name="OFFICE_TEL3" style="width:55px;text-align:right;padding:1px"/ b /></td>
                </tr>
                <input value="0081" maxlength="4" type="hidden" name="innerphone" / b />
                <tr>
                    <th height="25" class="fonts"  >FAX<span class="warning">*</span></th>
					<input type=hidden name="FAX_NO" >
                    <td height="25" colspan="2"><input maxlength="4" name="FAX_NO1" style="width:30px;text-align:right;padding:1px" / b />
                        -
                        <input maxlength="4" name="FAX_NO2" style="width:30px;text-align:right;padding:1px"/ b />
                        -
                        <input maxlength="4" name="FAX_NO3" style="width:55px;text-align:right;padding:1px"/ b /></td>
                </tr>
				<% 
					String strCphone = "";
					String strCphone1 = "";
					String strCphone2 = "";
					String strCphone3 = "";				
				%>
                <tr>
                    <th height="25" class="fonts" >�̵���Ź�ȣ<span class="warning">*</span></th>
					<input type=hidden name="CPHONE" >
                    <td height="25" colspan="2"><select name="CPHONE1" style="width:45px">
                            <option <%=strCphone1.equals("010")?"selected":""%> value="010">010</option>
							<option <%=strCphone1.equals("016")?"selected":""%> value="016">016</option>
							<option <%=strCphone1.equals("017")?"selected":""%> value="017">017</option>
							<option <%=strCphone1.equals("018")?"selected":""%> value="018">018</option>
							<option <%=strCphone1.equals("019")?"selected":""%> value="019">019</option>
							<option <%=strCphone1.equals("011")?"selected":""%> value="011">011</option>
                        </select>
                        -
                        <input maxlength="4" name="CPHONE2" style="width:30px;text-align:right;padding:1px" />
                        -
                        <input maxlength="4" name="CPHONE3" style="width:40px;text-align:right;padding:1px" /></td>
                </tr>
                <tr>
                    <th rowspan="3" align="middle" >�ٹ���</th>
                    <th align="middle" class="fonts" >�����ȣ</th>
                    <td height="25" colspan="4"><input name="POST_CD" id="POST_CD" type="hidden"/>
					<input maxlength="7" name="POST_CD1" id="POST_CD1" style="width:60px"/>
                        &nbsp;
                        <!-- 2015-04-24 ���� ��
                        <span class="list_bts"><a href="#" onclick="winopen('/common/SearchZipCodePop2.jsp','SearchZipCodePop','height=450,width=520,scrollbars=yes,resize=yes')">�����ȣ�˻�</a></span>
                         -->
                           <!-- 2015-04-24 ���� �� -->
                           <!-- <span class="list_bts"><a href="#" onclick="winopen('/common/doro.jsp','SearchZipCodePop','height=450,width=520,scrollbars=yes,resize=yes')">�����ȣ�˻�</a></span> -->
                           <span class="list_bts"><a href="#" onclick="wincall()">�����ȣ�˻�</a></span>
                     </td>
                </tr>
                <tr>
                    <th align="middle" class="fonts" >�⺻�ּ�</th>
                    <td height="25"><input maxlength="100" name="JUSO1" id="JUSO1" readonly  style="width:350px;"/></td>
                </tr>
                <tr>
                    <th align="middle" class="fonts" >���ּ�</th>
                    <td height="25" colspan="2"><input maxlength="100" name="JUSO2" style="width:350px;" /></td>
                </tr>
                <tr>
                    <th rowspan="2" align="middle" >������<span class="warning">*</span></th>
                    <th align="middle" class="fonts" >�־���</th>					
                    <td height="25" colspan="5">
					<%
							String strMsortCd = "";
							String strCdNm = "";
							
							String strType = "";
							String strCharge = "";
							
							String strChecked = "";
							String strDisabled = "";
							
							Hashtable objChargeInfoHt = new Hashtable();

							for(int i=0; i < objChargeInfoArry.size(); i++){
								objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
								strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
								strCdNm = (String)objChargeInfoHt.get("CD_NM");			
								

								if(strMsortCd.equals("999")){
					%>
											<input name="mchr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> onclick="makeTextBox(this,'MRK')" class=" borderNo"><%=strCdNm%>&nbsp;&nbsp;<BR>
					<%
								}else{
					%>
											<input name="mchr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> onclick="fun_check(this)" class=" borderNo"><%=strCdNm%>&nbsp;&nbsp;

					<%
								}
							}
					%>
					<span id="MRK"></span></td>
                </tr>
                <tr>
                    <th align="middle" class="fonts" >�ξ���</th>
                    <td height="25">
						<%
		
								for(int i=0; i < objChargeInfoArry.size(); i++){
									objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
									strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
									strCdNm = (String)objChargeInfoHt.get("CD_NM");

									if(strMsortCd.equals("999")){
						%>
												<input name="schr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> onclick="makeTextBox(this,'SRK')" class=" borderNo"><%=strCdNm%>&nbsp;&nbsp;<BR>
						<%
									}else{
						%>
												<input name="schr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> onclick="fun_checkm(this)" class=" borderNo"><%=strCdNm%>&nbsp;&nbsp;

						<%
									}
								}
						%>
						<span id="SRK"></span></td>
                </tr>
				<%
					String strRepFlag = "N";
				%>
                <tr>
                    <th height="25" colspan="2" align="middle">��ǥ��   ����<span class="warning">*</span></th>
                    <td height="25"><input value="Y" <%=strRepFlag.equals("Y")?"checked":""%> type="radio" name="REP_FLAG" class=" borderNo" />
                        ��ǥ��
                        <input type="radio" name="REP_FLAG" value="N" <%=strRepFlag.equals("N")?"checked":""%>  class=" borderNo"/>
                        �Ϲ�
						&nbsp;<font color="red">�� ��ǥ�ڷ� �����ϴ� ��� �ش����� �䱸�� ��� �� <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���� �˸����� (��ȸ��� ����� ����)</font>

					</td>
                </tr>
                <tr>
                    <th height="25" colspan="2">�������</th>
                    <td onmouseover="showtip(this,event,'����ũ��:��������(���� 5cm * ���� 4cm )')" title="����ũ��:��������(���� 5cm * ���� 4cm )" onmouseout="hidetip()" height="25" colspan="2">
					<input name="PHOTO_PATH" type="hidden" class="textfield">
					<input name="selFileShow" type="hidden" class="textfield" style="WIDTH: 170px" readonly>
					<input name="selFile" type="file" class="textfield" style="WIDTH:220px" onChange="javascript:showImageFile('selFile', 'selFileShow');">
				&nbsp&nbsp&nbsp&nbsp<a href="javascript:fun_view(document.frmPreJoinMember);"><img src="/image/button/bt_preview_icon.gif" width="71" height="19" align="absmiddle" border=0></a></td>
                </tr>
                <tr>
                    <th height="65" colspan="2">�ڱ�Ұ�</th>
                    <td height="65" colspan="2"><textarea wrap="hard" name="REMARK" style="width:400px; height:65px;"></textarea>
					</td>
                </tr>
            </table>
            <!-- /list -->
            <div id="btn_all" class="t_right"> <span class="list_bt"><a href="#" onclick="checkUserCharge(document.frmPreJoinMember);">�� û</a></span> <span class="list_bt"><a href="#" onclick="window.location='/index.html'">�� ��</a></span> </div>
            
            <!-- /����Ʈ ��ư--> 
            
            <span class="warning"> (*) ǥ�ô� �ʼ� �׸� �Դϴ�.</span> </div>
    </div>
    <div id="log_footer"> <span class="copy" ><img src="/images2/login/copyright.gif" width="448" height="26" /></span></div>
</div>
<input type=hidden name="USER_KIND" VALUE="999"><!-- ����ںз�(�ܺλ���ڴ� 999�� ����) -->
<input type=hidden name="STT_CD" VALUE="005">
<input type=hidden name="STT_CHG_RSN" VALUE="������û�� �ϼ̽��ϴ�.">
<input type=hidden name="USER_GRP_ID" VALUE="<%=strUserOutGrpId%>">
<input type=hidden name="SRCH_RECORD_CNT" VALUE="<%=strSrchRecordCnt%>">
<input type=hidden name="SRCH_DISPLAY_KIND" VALUE="<%=strSrchDisplayKind%>">
<input type=hidden name="GTHER_PERIOD" VALUE="<%=strGtherPeriod%>">
<input type=hidden name="GRD_CD" VALUE="">
<input type=hidden name="CG_DUTY" VALUE="">
<input type=hidden name="ORG_POSI_GBN" VALUE="1">
<input type="hidden" name="SFLAG" value="<%=strSFlag%>">
<input type=hidden name="REQ_SUBMT_FLAG" VALUE="<%=strReqSubmtFlag%>">
</form>
<script language="JavaScript">
<!--
//���� ÷��
function showImageFile(fileValue, showValue) { 
	eval("document.frmPreJoinMember."+showValue+".value = document.frmPreJoinMember."+fileValue+".value");
}
//-->
</script>
<script language="javascript">

function init()
{
	
	// �ʼ��Է�
	define('USER_NM', 'string', '�̸�', 1);	
	define('ORGAN_NM', 'string', '���', 1);	
	define('ORGAN_ID', 'string', '���', 1);	
	define('DEPT_NM', 'string', '�μ�', 1);	
	define('EMAIL', 'string', '�̸���', 1);	
	define('OFFICE_TEL1', 'num', '�繫����ȭ��ȣ', 2,3);	
	define('OFFICE_TEL2', 'num', '�繫����ȭ��ȣ', 2,4);	
	define('OFFICE_TEL3', 'num', '�繫����ȭ��ȣ', 3,4);	
	define('FAX_NO1', 'num', '�ѽ���ȣ', 2,3);	
	define('FAX_NO2', 'num', '�ѽ���ȣ', 2,4);	
	define('FAX_NO3', 'num', '�ѽ���ȣ', 3,4);	
	//define('CPHONE1', 'num', '�ڵ���', 3,3);	
	define('CPHONE2', 'num', '�ڵ���', 3,4);	
	define('CPHONE3', 'num', '�ڵ���', 3,4);	
	//define('POST_CD1', 'num', '�����ȣ', 3,3);	
	//define('POST_CD2', 'num', '�����ȣ', 3,3);	
	//define('JUSO2', 'string', '���ּ�', 1);	
	//define('REP_FLAG', 'string', '��ǥ�ڿ���', 1);	


}
function checkValidation(frm)
{

	
	//frm.POST_CD.value = frm.POST_CD1.value + frm.POST_CD2.value;	
	frm.POST_CD.value = frm.POST_CD1.value;
	frm.OFFICE_TEL.value = frm.OFFICE_TEL1.value + "-"+ frm.OFFICE_TEL2.value + "-"+ frm.OFFICE_TEL3.value;
	frm.CPHONE.value = frm.CPHONE1.value +"-"+ frm.CPHONE2.value + "-"+ frm.CPHONE3.value;
	frm.FAX_NO.value = frm.FAX_NO1.value + "-"+ frm.FAX_NO2.value + "-"+ frm.FAX_NO3.value;
	

	if( OnValidationSubmit() == true)
	{

		if(frm.selFile.value != ""){

			var vafile = frm.selFile.value.substr(frm.selFile.value.length - 4, frm.selFile.value.length);

			frm.PHOTO_PATH.value=frm.selFile.value.substr(frm.selFile.value.lastIndexOf("\\")+1,frm.selFile.value.length);
		

			if((vafile.toLowerCase() != ".gif") && (vafile.toLowerCase() != ".jpg") &&
			   (vafile.toLowerCase() != ".bmp") && (vafile.toLowerCase() != ".jpeg")){
				alert("���������� Ȯ����� .gif, .jpg .jpeg .bmp �� ����� �� �ֽ��ϴ�. (." + vafile+")");
				return false;
			}	

		}
		return true;
	}else{

		return false;
	}

}

function selectZipCd(varZipCd, varAddr1)
{
	var frm = document.forms[0];
	frm.POST_CD1.value = varZipCd;
	/* frm.POST_CD1.value = varZipCd1;
	frm.POST_CD2.value = varZipCd2; */
	frm.JUSO1.value = varAddr1;
}
function selectOrgan(organId,organNm,organNo,homeUrl,Juso1,Juso2) {
	var frm = document.forms[0];
	frm.ORGAN_ID.value = organId;
	frm.ORGAN_NM.value = organNm;
	frm.ORGAN_NO.value = organNo;
	frm.HOME_URL.value = homeUrl;
	frm.ORGAN_JUSO1.value = Juso1;
	frm.ORGAN_JUSO2.value = Juso2;

}

function viewFile() {
	var frm = document.forms[0];
	var img = frm.selFile.value;

	
	img=img.replace(/:/, "|");
    img=img.replace(/\\/gi, "/");
	img= 'file:///' + img;

	
	winBG=window.open("", "", "width=200,height=190,resizable=false");
	winBG.document.open();
	winBG.document.write("<html>");
	winBG.document.write("<head></head>");
	winBG.document.write("<body background='"+img+"'></body>");
	winBG.document.write("</html>");
	winBG.document.close();
	winBG.window.focus();
}
</script>
</body>
</html>