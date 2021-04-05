<%@ page contentType="text/html;charset=euc-kr" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ page import="nads.lib.gpki.ips.driver.*" %>
<%@ page import="nads.lib.reqsubmit.encode.*" %>
<%@ page import="kr.co.kcc.bf.log.Log" %>

<%@ page import="java.security.cert.*" %>
<%@ page import="java.security.spec.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javak.crypto.*" %>
<%@ page import="javak.crypto.spec.*" %>
<%@ page import="java.util.*" %>
<!-- <%@ page import="com.gpki.gpkiapi_jni" %> -->
<!-- <%@ page import="ksign.jce.util.*" %> -->
<%@ page import="javak.crypto.*" %>
<%@ page import="javak.crypto.spec.*" %>
<!-- <%@ page import="ksign.jce.provider.pkcs.*" %> -->
<!-- <%@ page import="ksign.jce.provider.validate.ValidateCert" %> -->


<%@ page import="com.raonsecure.ksbiz.*" %>
<%@ page import="com.raonsecure.ksbiz.servlet.*" %>
<%@ page import="com.raonsecure.ksbiz.util.*" %>
<%@ page import="com.raonsecure.ksbiz.crypto.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">




<%
	String idn = "";
	String signData = "";
	String vidRandom = "";
	String errorMsg1 = "";
	String errorMsg2 = "";
	String errorMsg3 = "";
	int    errorCode1=-1;
	int    errorCode2=-1;
	String vidmsg = "";

	String regsid1 = "";
	String regsid2 = "";
	String resid_no = "";
	String emp_no = ""; //���λ���� ���νĺ���ȣ

	String strUserInGrpId = ""; 
	String strUserOutGrpId = ""; 
	String strSrchRecordCnt = ""; 
	String strSrchDisplayKind = "";
	String strGtherPeriod = "";
	String strReqSubmtFlag = "";
	String strJuminNoTemp = "";
	String strCertDn = "";
	String strRetVal = "";
	String username = "";

	boolean isAlreadyExistDn = false;
		
	regsid1 = request.getParameter("regsid1")==null?"":request.getParameter("regsid1") ;
	regsid2 = request.getParameter("regsid2")==null?"":request.getParameter("regsid2") ;
	resid_no = regsid1+regsid2;
	emp_no = request.getParameter("emp_no")==null?"":request.getParameter("emp_no");//���λ���� ���νĺ���ȣ
//	strCertDn = request.getParameter("CERT_DN")==null?"":request.getParameter("CERT_DN") ;//������ dn��.
//	strRetVal = request.getParameter("retVal");//������ �����
	username =  request.getParameter("username");
	
	int nOrganResult = 0;
	int nUserResult = 0;
/*
	System.out.println("strRetVal===>"+strRetVal);
	System.out.println("==================>"+strCertDn);

	int nStartIndex = 0;
	int nIndex = 0;
	int n = 0;
	String arg[] = new String[3];
	Base64Code objBase64Code = new Base64Code();
	int nUserResult = 0;
	int nOrganResult = 0;

	strJuminNoTemp  = objBase64Code.encode(resid_no);

	while(nIndex != -1){
		nIndex = strRetVal.indexOf("|",nStartIndex);
		if(nIndex == -1){
			arg[n] = strRetVal.substring(nStartIndex,strRetVal.length());
		}else{
			arg[n] = strRetVal.substring(nStartIndex,nIndex);
		}
		nStartIndex = nIndex+1;
		n++;
	}
*/
	
	KSBiz_v2 ksobj = null;


	nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();
	java.util.Hashtable objHshReqUserInfo = new java.util.Hashtable();
	java.util.Hashtable objHshParam = new java.util.Hashtable();
		
	try{

		ksobj = new KSBiz_v2();
		ksobj.libInit();
		System.out.println("lib init success");
		
		signData = request.getParameter("ksbizSig");
		vidRandom = request.getParameter("ksbizVidRandom");
		
//		System.out.println("=========== signData :: " + signData);
//		System.out.println("=========== vidRandom :: " + vidRandom);

		// 1. ���ڼ��� ����
		ksobj.verify(signData);
		errorCode1 = ksobj.getErrorCode();
		
		System.out.println("=========== errorCode1 :: " + errorCode1);

		if(errorCode1 != 0)
		{
			errorMsg1 = ksobj.getErrorMsg();
			out.println("<script> alert('��������� �����߽��ϴ�. �ٽ� �õ��� �ֽʽÿ�.'); history.back();</script>");
		}
		else
		{
			vidmsg = ksobj.getCertInfo(KSBizCertInfo.VIDMSG);
			// 2. ����Ȯ��(VID) ����
			ksobj.verifyIdv(vidmsg, vidRandom, resid_no);
			System.out.println("vidmsg : " + vidmsg);
			System.out.println("vidRandom : " + vidRandom);
			
			errorCode2 = ksobj.getErrorCode();
			if(errorCode2 != 0)
			{
				errorMsg2 = ksobj.getErrorMsg();
				out.println("<script> alert('����Ȯ�ο� �����߽��ϴ�. �ùٸ� �������� �����Ͽ� �ֽʽÿ�.'); history.back();</script>");	
			}
			else
			{
				strCertDn = ksobj.getCertInfo(KSBizCertInfo.SUBJECTDN);	 //dn �� ����
			}
		}


		Config objConfig = PropertyConfig.getInstance();
		strUserInGrpId = objConfig.get("join.userInGrpId");
		strUserOutGrpId = objConfig.get("join.userOutGrpId");
		strSrchRecordCnt = objConfig.get("join.srchRecordCnt");  
		strSrchDisplayKind = objConfig.get("join.srchDisplayKind");
		strGtherPeriod = objConfig.get("join.gtherPeriod");  
		strReqSubmtFlag = objConfig.get("join.reqSubmtFlag4Submit"); 
		
		if(regsid1.equals("") != true)
		{
			
			if(strCertDn.indexOf("Government") != -1){
				
				System.out.println("::::::::::::: Government ::::: ");
				System.out.println("strCertDn ::::: "+strCertDn);
				System.out.println("eventdate ::::: "+regsid1);
				System.out.println("empNo ::::: "+emp_no);
				System.out.println("username ::::: "+username);

				objHshParam.put("CERT_DN",strCertDn);
				objHshParam.put("eventdate",regsid1);
				objHshParam.put("empNo",emp_no);
				objHshParam.put("username",username);
			}else{

				System.out.println("eventdate ::::: "+regsid1);
				System.out.println("empNo ::::: "+emp_no);
				System.out.println("username ::::: "+username);

				 objHshParam.put("CERT_DN","");
				 objHshParam.put("eventdate",regsid1);
				 objHshParam.put("empNo",emp_no);
				 objHshParam.put("username",username);
			}
			objHshReqUserInfo = objJoinMemberDelegate.getUserInfo3(objHshParam);
		}

		System.out.println("CERT_DN  >>>>"+objHshReqUserInfo.get("CERT_DN"));

		if(objHshReqUserInfo.get("CERT_DN") != null && objHshReqUserInfo.get("CERT_DN").toString().equals(strCertDn)){
			
			System.out.println("CERT_DN ���� �ִ�.");

			isAlreadyExistDn = true;
			objHshReqUserInfo.put("USER_ID","");
			objHshReqUserInfo.put("USER_NM","");
			objHshReqUserInfo.put("STT_CD","000");
			objHshReqUserInfo.put("JUMIN_NO","");
			objHshReqUserInfo.put("INOUT_GBN","");
			objHshReqUserInfo.put("REP_FLAG","");
			objHshReqUserInfo.put("ORGAN_NM","");
			objHshReqUserInfo.put("DEPT_NM","");
			objHshReqUserInfo.put("POSI_NM","");
			objHshReqUserInfo.put("GRD_NM","");
			objHshReqUserInfo.put("USER_DN","");
			objHshReqUserInfo.put("EMAIL","");
			objHshReqUserInfo.put("OFFICE_TEL","");
			objHshReqUserInfo.put("CPHONE","");
			objHshReqUserInfo.put("FAX_NO","");
			objHshReqUserInfo.put("POST_CD","");
			objHshReqUserInfo.put("JUSO1","");
			objHshReqUserInfo.put("JUSO2","");
			objHshReqUserInfo.put("CG_DUTY","");
			objHshReqUserInfo.put("REMARK","");
			objHshReqUserInfo.put("INOUT_GBN","I");
		}

		if(objHshReqUserInfo.isEmpty()){

			System.out.println("CERT_DN ���� isEmpty().");

			objHshReqUserInfo.put("USER_ID","");
			objHshReqUserInfo.put("USER_NM","");
			objHshReqUserInfo.put("STT_CD","000");
			objHshReqUserInfo.put("JUMIN_NO","");
			objHshReqUserInfo.put("INOUT_GBN","");
			objHshReqUserInfo.put("REP_FLAG","");
			objHshReqUserInfo.put("ORGAN_NM","");
			objHshReqUserInfo.put("DEPT_NM","");
			objHshReqUserInfo.put("POSI_NM","");
			objHshReqUserInfo.put("GRD_NM","");
			objHshReqUserInfo.put("USER_DN","");
			objHshReqUserInfo.put("EMAIL","");
			objHshReqUserInfo.put("OFFICE_TEL","");
			objHshReqUserInfo.put("CPHONE","");
			objHshReqUserInfo.put("FAX_NO","");
			objHshReqUserInfo.put("POST_CD","");
			objHshReqUserInfo.put("JUSO1","");
			objHshReqUserInfo.put("JUSO2","");
			objHshReqUserInfo.put("CG_DUTY","");
			objHshReqUserInfo.put("REMARK","");
			objHshReqUserInfo.put("INOUT_GBN","I");

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


<%
//	String strOrganNo =  objHshReqUserInfo.get("ORGAN_NO") != null ?  (String)objHshReqUserInfo.get("ORGAN_NO"):"";
	String strOrganNm = StringUtil.getNVLNULL((String)objHshReqUserInfo.get("ORGAN_NM")).trim() ;
	
	System.out.println("strOrganNm :: " + strOrganNm);


	//arg[0] = "cn=�ѱ��ߺι���(������)11111,ou=naps,o=NCASign,c=KR   ";		
	if(strCertDn.indexOf("�����") != -1 || strCertDn.indexOf("�׽�Ʈ���") != -1){
		nOrganResult = 0;
		nUserResult = 0;
	}else{
		while(true){
			if( strOrganNm.lastIndexOf("(") > 0 &&	strOrganNm.endsWith(")") == true)
				strOrganNm = strOrganNm.substring(0,strOrganNm.lastIndexOf("("));
			else
				break;
		}

		if(strCertDn.indexOf(strOrganNm) == -1 )
			nOrganResult = 1;

		if(strCertDn.indexOf("naps") == -1)
			nOrganResult = 2;
		
		if(strCertDn.indexOf("NCASign") != -1 )
		{
			if(strCertDn.indexOf("naps") ==-1)
				nOrganResult=2;
		}
	}

	System.out.println("nOrganResult ========================== " + nOrganResult);
	System.out.println("isAlreadyExistDn :  " + isAlreadyExistDn);
	System.out.println("STT_CD :  " + objHshReqUserInfo.get("STT_CD"));

	if(nOrganResult == 1){

		out.println("<script> alert('�ý����� ������ �������� ������� �ٸ��ϴ�. �����ڿ��� �����Ͽ��ֽʽÿ�.'); history.back();</script>");	

	}else if(nOrganResult == 4){

		out.println("<script> alert('�ߺ��� �������� �ֽ��ϴ�. �����ڿ��� �����Ͽ��ֽʽÿ�.'); history.back();</script>");	

	}else if(nUserResult != 0){
		if(objHshReqUserInfo.get("STT_CD").equals("001")){		
			out.println("<script> alert('ȭ�� �ϴ��� �Ϸ��ư�� �����ø� ����� �Ϸ�˴ϴ�');</script>");
		}else{
			out.println("<script> alert('�ùٸ� �ֹι�ȣ�� �������� �����Ͽ� �ֽʽÿ�.'); history.back();</script>");	
		}
	}else if(nOrganResult == 100){

		out.println("<script> alert('������������� ���ο��������� �ƴմϴ�. �ùٸ� �������� �����Ͽ� �ֽʽÿ�.'); history.back();</script>");	

	}else if(objHshReqUserInfo.get("ORGAN_ID")!=null && objHshReqUserInfo.get("ORGAN_ID").equals("") && objHshReqUserInfo.get("STT_CD").equals("006") == true && isAlreadyExistDn != true){

		out.println("<script> alert('�ҼӺμ� ������ �����ϴ�. �����ڿ��� �����Ͻʽÿ�.'); document.location = '/index.html';</script>");	

	}else if(isAlreadyExistDn == true && objHshReqUserInfo.get("STT_CD").equals("001")){

		out.println("<script> alert('ȭ�� �ϴ��� �Ϸ��ư�� �����ø� ����� �Ϸ�˴ϴ�');</script>");	

	}else if(isAlreadyExistDn == true && objHshReqUserInfo.get("STT_CD").equals("000")){

		out.println("<script> alert('�̹� ��� �Ǿ��ִ� �������Դϴ�.'); document.location = '/index.html';</script></script>");

	}else if(objHshReqUserInfo.get("STT_CD").equals("000")){

		out.println("<script> alert('�α��� ȭ�鿡�� [����� ��� ��û]�� �ϼž� �մϴ�.'); document.location = '/index.html';</script></script>");

	}else if(objHshReqUserInfo.get("STT_CD").equals("001")){
		out.println("<script> alert('ȭ�� �ϴ��� �Ϸ��ư�� �����ø� ����� �Ϸ�˴ϴ�'); </script>");

	}else if(objHshReqUserInfo.get("STT_CD").equals("002")){

		out.println("<script> alert('������������Դϴ�. �����ڿ��� �����Ͻʽÿ�.'); document.location = '/index.html';</script>");

	}else if(objHshReqUserInfo.get("STT_CD").equals("003")){

		out.println("<script> alert('Ż�� ������Դϴ�. �����ڿ��� �����Ͻʽÿ�.'); document.location = '/index.html';</script>");

	}else if(objHshReqUserInfo.get("STT_CD").equals("005")){

		out.println("<script> var retVal = confirm('�����ڰ� ��� ó���� Ȯ�� ���Դϴ�. ���������� ���ðڽ��ϱ�?');  if(retVal == false) document.location = '/index.html'; else document.location = '/join/RegistUserInfoCenter2.jsp?eventdate="+regsid1+"&username="+username+"'</script>");

	}else if(objHshReqUserInfo.get("STT_CD").equals("006")){

		out.println("<script> alert('�α��� ȭ�鿡�� [����� ��� Ȯ��]�� �ϼž� �մϴ�.'); document.location = '/index.html';</script></script>");

	}else if(objHshReqUserInfo.get("STT_CD").equals("007")){

		out.println("<script> alert('�����ڰ� ��û�� �ݷ��Ͽ����ϴ�. �����ڿ��� �����Ͻʽÿ�.'); document.location = '/index.html';</script>");

	}
%>

<%
	String webPath = ""; //�̹��� ������ ������ ���
	String imgPath = ""; //�����̹��� ���
	String strImgPath="";



	String strInOutGbn = StringUtil.getNVLNULL((String)objHshReqUserInfo.get("INOUT_GBN"));
	String strOrganTitle = strInOutGbn.equals("I") == true? "�μ���":"�����";
	String strUserGrpId = strInOutGbn.equals("I") == true? strUserInGrpId:strUserOutGrpId;
	


	
	try {
	
		Config objConfig = PropertyConfig.getInstance(); //������Ƽ

		webPath = objConfig.get("nads.dsdm.url");
		imgPath = objConfig.get("user.photo.path");
		strImgPath = webPath + imgPath;

	} catch (ConfigException objConfigEx) {
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>

<!-- ���������н��� -->
<%
	nads.dsdm.app.activity.userinfo.UserInfoDelegate objUserInfoDelegate = new nads.dsdm.app.activity.userinfo.UserInfoDelegate();
	
	ArrayList objChargeInfoArry = new ArrayList();
	ArrayList objUserChargeArry = new ArrayList();

	String strError = "no";	
	String strUserId = (String)objHshReqUserInfo.get("USER_ID");
	try
	{
		objChargeInfoArry = objUserInfoDelegate.selectChargeCdInfo();
		objUserChargeArry = objUserInfoDelegate.selectUserCharge(strUserId);
	}
	catch(AppException objAppEx)
	{	
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
	
%>


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
<script type="text/javascript" src="/zipinfo/js/jquery-1.8.3.min.js"></script>
<script language="JavaScript">

<!--
//���� ÷��
function showImageFile(fileValue, showValue) { 
	eval("document.frmJoinMember."+showValue+".value = document.frmJoinMember."+fileValue+".value");
}
//-->
</script>
<script language="javascript">
function init()

{
	// �ʼ��Է�
	define('USER_NM', 'string', '�̸�', 1);	
	//define('JUMIN_NO', 'string', '�ֹε�Ϲ�ȣ', 1);	
	//define('JUMIN_NO1', 'string', '�ֹε�Ϲ�ȣ', 6,6);	
	//define('JUMIN_NO2', 'string', '�ֹε�Ϲ�ȣ', 7,7);	
	//define('ORGAN_NM', 'string', '���', 1);	
	//define('ORGAN_ID', 'string', '���', 1);	
	//define('DEPT_NM', 'string', '�μ�', 1);	
	define('EMAIL', 'string', '�̸���', 1);	
	define('OFFICE_TEL1', 'num', '�繫����ȭ��ȣ', 2,3);	
	define('OFFICE_TEL2', 'num', '�繫����ȭ��ȣ', 3,4);	
	define('OFFICE_TEL3', 'num', '�繫����ȭ��ȣ', 4,4);	
	define('FAX_NO1', 'num', '�ѽ���ȣ', 2,3);	
	define('FAX_NO2', 'num', '�ѽ���ȣ', 3,4);	
	define('FAX_NO3', 'num', '�ѽ���ȣ', 4,4);	
	//define('CPHONE1', 'num', '�ڵ���', 3,3);	
	define('CPHONE2', 'num', '�ڵ���', 3,4);	
	define('CPHONE3', 'num', '�ڵ���', 4,4);	
	//define('POST_CD1', 'num', '�����ȣ', 3,3);	
	//define('POST_CD2', 'num', '�����ȣ', 3,3);	
	//define('JUSO2', 'string', '���ּ�', 1);	
	//define('REP_FLAG', 'string', '��ǥ�ڿ���', 1);
}



function checkValidation(frm){
	//frm.POST_CD.value = frm.POST_CD1.value + frm.POST_CD2.value;
	//frm.JUMIN_NO.value = frm.JUMIN_NO1.value + frm.JUMIN_NO2.value;
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
				alert("���������� Ȯ����� .gif, jpg .jpeg .bmp �� ����� �� �ֽ��ϴ�. (." + vafile+")");
				return false;
			}	
		}
		frm.submit();
		return true;
	}else{
		return false;
	}
}



function selectZipCd(varZipCd1, varZipCd2, varAddr1)
{
	var frm = document.forms[0];
	frm.POST_CD1.value = varZipCd1;
	frm.POST_CD2.value = varZipCd2;
	frm.JUSO1.value = varAddr1;
}

function selectOrgan(organId,organNm) {
	var frm = document.forms[0];
	frm.ORGAN_ID.value = organId;
	frm.ORGAN_NM.value = organNm;
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
	  $("#JUSO1").val(data.addr);
}
</script>
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
			var vafile = frm.selFileShow.value.substr(frm.selFileShow.value.length - 4, frm.selFileShow.value.length);
			
			if((vafile.toLowerCase() != ".gif") && (vafile.toLowerCase() != ".jpg") &&
			   (vafile.toLowerCase() != ".bmp") && (vafile.toLowerCase() != ".jpeg")){
				alert("���������� Ȯ����� .gif, .jpg .jpeg .bmp �� ����� �� �ֽ��ϴ�." + vafile);
				return;
			}	
		} 
				
		img=frm.selFileShow.value;
		

		if(img.indexOf("C:") ==0){
			img=img.replace(/:/, "|");
			img=img.replace(/\\/gi, "/");
			img="file:///"+img;
		}else
		{
			img = "http://<%=request.getServerName()%>"+":"+"<%=request.getServerPort()%>"+img;
		}


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

function fun_viewRemoteFile(frm) {
		var img;

		if(img == "")
		{
			alert("���õ� ������ �����ϴ�.");
			return;
		}

		if(img != ""){
			var vafile = frm.selFileShow.value.substr(frm.selFileShow.value.length - 4, frm.selFileShow.value.length);
			alert(vafile);
			if((vafile.toLowerCase() != ".gif") && (vafile.toLowerCase() != ".jpg") &&
			   (vafile.toLowerCase() != ".bmp") && (vafile.toLowerCase() != ".jpeg")){
				alert("���������� Ȯ����� .gif, .jpg .jpeg .bmp �� ����� �� �ֽ��ϴ�." + vafile);
				return;
			}	
		} 
				
		img=frm.selFile.value;
		img=img.replace(/:/, "|");
		img=img.replace(/\\/gi, "/");
		img="http:///"+img;

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
			
			varCheck = 'document.frmJoinMember.s' + varObj.name.substring(1, varObj.name.length)
			                      + '.disabled = true';
		}else{
			varCheck = 'document.frmJoinMember.s' + varObj.name.substring(1, varObj.name.length)
			                      + '.disabled = false';
			
		}
		eval(varCheck);		 
	}
	
	function fun_checkm(varObj){
		var varCheck ='';
		if(varObj.checked == true){
			varCheck = 'document.frmJoinMember.m' + varObj.name.substring(1, varObj.name.length)
			                      + '.disabled = true';
		}else{
			varCheck = 'document.frmJoinMember.m' + varObj.name.substring(1, varObj.name.length)
			                      + '.disabled = false';
			
		}
		eval(varCheck);		 
	}

function makeTextBox(chbox,divNm)
{
 eval(divNm).innerHTML = "";

 if(chbox.checked == true)
	eval(divNm).innerHTML = "<input type='text' name='"+divNm+"' class='textfield' style='WIDTH: 200px' maxlength=15 >";
 else
	 eval(divNm).visibility="hidden";
 

}

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
<form action="/join/JoinMemberProc.jsp" method="post" name="frmJoinMember" encType="multipart/form-data" onsubmit="return checkValidation(this)">

<div id="log_wrap">

    <div class="login">

        <h1><img src="/images2/login/logo02.gif" width="194" height="46" /></h1>

        <div class="user_con"> <br />

            <br />

            <!-- list --> 
			<input type=hidden name='organ_no_old' value='<%=objHshReqUserInfo.get("ORGAN_NO")%>'>

            <span class="list02_tl">����� ���� �Է�</span> <span class="list_total">(*) ǥ�ô� �ʼ� �׸� �Դϴ�.</span>

            <table border="0" cellspacing="0" cellpadding="0" class="list03" >

                <tr>
				<%
					String strTempPath = "";
					if(objHshReqUserInfo.get("PHOTO_PATH") != null && !((String)objHshReqUserInfo.get("PHOTO_PATH")).equals("")){
						strTempPath = (String)objHshReqUserInfo.get("PHOTO_PATH");
					}else{
						strTempPath = "/images2/foundation/pic.gif";
					}
				%>

                    <th width="18%" rowspan="3" align="middle" valign="top"><img src="<%=strTempPath%>" width="110" height="120" class="pic" /></th>

                    <th width="85" align="middle">����<span class="warning">*</span></th>

                    <td ><%=objHshReqUserInfo.get("USER_NM")%>
					<input type=hidden name="CERT_DN" VALUE="<%=strCertDn%>">
					<input type=hidden name="USER_NM" VALUE="<%=objHshReqUserInfo.get("USER_NM")%>">
					<input type=hidden name="USER_ID" VALUE="<%=objHshReqUserInfo.get("USER_ID")%>">
					<input type=hidden name="INOUT_GBN" VALUE="<%=strInOutGbn%>">
					</td>

                </tr>
				<tr>

                    <th align="middle">�������</th>

                    <td height="25">
					<input type=hidden name="eventdate" value="<%=regsid1%>">
					<%=regsid1.substring(0,2)%>��&nbsp;<%=regsid1.substring(2,4)%>��&nbsp;<%=regsid1.substring(4,6)%>��
					</td>

                </tr>
                
				<!--

                <tr>

                    <th colspan="2" align="middle" valign="top">��������</th>

                    <td height="25">2004��06��21��</td>

                </tr>
				-->
				<% if(StringUtil.getNVLNULL(strInOutGbn).equals("X")) { %>
				  <tr>

                    <th align="middle" valign="middle">�μ���</th>

                    <td height="25"><input name="DEPT_NM" style="width:120px;" VALUE="<%=objHshReqUserInfo.get("DEPT_NM")%>" / b /></td>

                  </tr>				 
				  <% } else {%>
					<input type=hidden name="DEPT_NM" VALUE=<%=objHshReqUserInfo.get("DEPT_NM")%> >
				  <% }%>


                <tr>

                <%
			            if (StringUtil.getNVLNULL(strInOutGbn).equals("X")) {
	 	            %>
                    <th colspan="2" align="middle" valign="top">������</th>
                <% } else {%>
                	<th colspan="1" align="middle" valign="middle">������</th>                
                <% }%>
                    <td height="25"><input name="POSI_NM" style="width:120px;" value="<%=objHshReqUserInfo.get("POSI_NM")%>" / b /></td>

                </tr>

                <tr>

                    <th colspan="2" align="middle" valign="top">���޸�</th>

                    <td height="25"><input name="GRD_NM" style="width:120px;"  value="<%=objHshReqUserInfo.get("GRD_NM")%>" / b /></td>

                </tr>

                <tr>

                    <th colspan="2" align="middle" valign="top">e-mail<span class="warning">*</span></th>

                    <td height="25"><input maxlength="30" name="EMAIL"  style="width:250px;" VALUE="<%=objHshReqUserInfo.get("EMAIL")%>"/></td>

                </tr>
				<% 
				String strTel = (String)objHshReqUserInfo.get("OFFICE_TEL");
				
				String strTel1 = "";
				String strTel2 = "";
				String strTel3 = "";
				
				if(strTel != null && strTel.equals("") != true && strTel.indexOf("-") != -1){


					if(strTel.split("-").length > 2){
						strTel1 = strTel.split("-")[0];
						strTel2 = strTel.split("-")[1];
						strTel3 = strTel.split("-")[2];
					}else{
						strTel2 = strTel.split("-")[0];
						strTel3 = strTel.split("-")[1];
				
					}
		
				}

			    %>

                <tr>

                    <th rowspan="3" align="middle" >��ȭ��ȣ</th>
					<input type=hidden name="OFFICE_TEL" VALUE=<%=strTel%>>

                    <th height="25" class="fonts" >�繫��<span class="warning">*</span></th>

                    <td height="25" colspan="2"><input maxlength="4" name="OFFICE_TEL1" style="width:30px" VALUE="<%=strTel1%>" />

                        -

                        <input maxlength="4" name="OFFICE_TEL2" style="width:30px" VALUE="<%=strTel2%>" />

                        -

                        <input maxlength="4" name="OFFICE_TEL3" style="width:55px" VALUE="<%=strTel3%>" /></td>

                </tr>

				<% 
				String strFax = (String)objHshReqUserInfo.get("FAX_NO");
				String strFax1 = "";
				String strFax2 = "";
				String strFax3 = "";
				
				
				if(strFax != null && strFax.equals("") != true && strFax.indexOf("-") != -1){
					if(strFax.split("-").length > 2){
						strFax1 = strFax.split("-")[0];
						strFax2 = strFax.split("-")[1];
						strFax3 = strFax.split("-")[2];	
					}else{
						strFax2 = strFax.split("-")[0];
						strFax3 = strFax.split("-")[1];		
					}
				}

			   %>

                <tr>

                    <th height="25" class="fonts"  >FAX<span class="warning">*</span></th>
					<input type=hidden name="FAX_NO" VALUE="<%=strFax%>">

                    <td height="25" colspan="2"><input maxlength="4" name="FAX_NO1" style="width:30px" VALUE="<%=strFax1%>" />

                        -

                        <input maxlength="4" name="FAX_NO2" style="width:30px" VALUE="<%=strFax2%>" />

                        -

                        <input maxlength="4" name="FAX_NO3" style="width:55px" VALUE="<%=strFax3%>" /></td>

                </tr>
				<% 
					String strCphone = (String)objHshReqUserInfo.get("CPHONE");
					String strCphone1 = "";
					String strCphone2 = "";
					String strCphone3 = "";		
					
					if(strCphone != null && strCphone.equals("") != true && strCphone.indexOf("-") != -1){
						strCphone1 = strCphone.split("-")[0];
						strCphone2 = strCphone.split("-")[1];
						strCphone3 = strCphone.split("-")[2];		
					}
				%>

                <tr>

                    <th height="25" class="fonts" >�̵���Ź�ȣ<span class="warning">*</span></th>
					<input type=hidden name="CPHONE" VALUE=<%=strCphone%>>

                    <td height="25" colspan="2"><select name="CPHONE1" style="width:45px">

                            <option <%=strCphone1.equals("010")?"selected":""%> value="010">010</option>
							<option <%=strCphone1.equals("016")?"selected":""%> value="016">016</option>
							<option <%=strCphone1.equals("017")?"selected":""%> value="017">017</option>
							<option <%=strCphone1.equals("018")?"selected":""%> value="018">018</option>
							<option <%=strCphone1.equals("019")?"selected":""%> value="019">019</option>
							<option <%=strCphone1.equals("011")?"selected":""%> value="011">011</option>

                        </select>

                        -

                        <input maxlength="4" name="CPHONE2" style="width:30px" value="<%=strCphone2%>" />

                        -

                        <input maxlength="4" name="CPHONE3" style="width:40px" value="<%=strCphone3%>" /></td>

                </tr>
				<%
					String strPostCd = (String)objHshReqUserInfo.get("POST_CD");
					String strJuso1 =  (String)objHshReqUserInfo.get("JUSO1");
					String strJuso2 =  (String)objHshReqUserInfo.get("JUSO2");

					if(StringUtil.getNVLNULL(strInOutGbn).equals("I")) { 
						//���λ���ڴ� ���� ����� �ּ�(�����ȣ, �ּ�1, �ּ�2�� ���������)�� ǥ���Ѵ�
						strPostCd = (String)objHshReqUserInfo.get("ORGAN_POST_CD");
						strJuso1 =  (String)objHshReqUserInfo.get("ORGAN_JUSO1");
						strJuso2 = " ";
					}

					/* String strPostCd1 = "";
					String strPostCd2 = "";

					if(strPostCd != null && strPostCd.equals("") != true){
						strPostCd1 = strPostCd.substring(0,3);
						strPostCd2 = strPostCd.substring(3,6);
					} */
					
				%>

                <tr>

                    <th rowspan="3" align="middle" >�ٹ���</th>

                    <th align="middle" class="fonts" >�����ȣ</th>

                    <td height="25" colspan="4"><input name="POST_CD" type="hidden" VALUE="<%=strPostCd%>"/>
					<input maxlength="7" name="POST_CD" id="POST_CD" readonly style="width:60px" value="<%=strPostCd%>"/>
                    </td>

                </tr>

                <tr>

                    <th align="middle" class="fonts" >�⺻�ּ�</th>

                    <td height="25"><input maxlength="100" name="JUSO1" id="JUSO1" readonly  style="width:350px;" value="<%=strJuso1%>"/></td>

                </tr>

                <tr>

                    <th align="middle" class="fonts" >���ּ�</th>

                    <td height="25" colspan="2"><input maxlength="100" name="JUSO2" style="width:350px;" VALUE="<%=strJuso2%>" /></td>

                </tr>
				<%
				if(strInOutGbn.equals("X") ==true)
				{
				%>

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
					String strRemark = "";
					
					Hashtable objChargeInfoHt = new Hashtable();
					Hashtable objUserChargeHt = new Hashtable();

					for(int i=0; i < objChargeInfoArry.size(); i++){
						objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
						strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
						strCdNm = (String)objChargeInfoHt.get("CD_NM");			
						
						strChecked = "";
						strDisabled = "";
						strRemark = "";
						for(int k=0; k < objUserChargeArry.size(); k++){
							objUserChargeHt = (Hashtable)objUserChargeArry.get(k);
							strType = (String)objUserChargeHt.get("CHARGE_TYPE");
							strCharge = (String)objUserChargeHt.get("CHARGE_CD");
							strRemark = (String)objUserChargeHt.get("REMARK");
							if(strType.equals("S")){
								if(strCharge.equals(strMsortCd) && !strMsortCd.equals("999")){
									strDisabled = "disabled";
									break;
								}
								continue;
							}
							if(strCharge.equals(strMsortCd)){
								strChecked = "checked";
								break;
							}
						}


						if(strType.equals("S"))
							strRemark="";

						if( strMsortCd.equals("999")){
					%>
											<input name="mchr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%> onclick="makeTextBox(this,'MRK')" class=" borderNo"><%=strCdNm%>&nbsp;&nbsp;<BR>
											<SPAN id="MRK"> <input name="MRK" value="<%=strRemark%>"  class='textfield' style='WIDTH: 200px' maxlength=15>&nbsp;&nbsp;</SPAN>
					<%
								}else{
					%>
											<input name="mchr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> onclick="fun_check(this)" class=" borderNo"><%=strCdNm%>&nbsp;&nbsp;

					<%
								}
							}
					%>
					</td>

                </tr>

                <tr>

                    <th align="middle" class="fonts" >�ξ���</th>

                    <td height="25">
						<%
						for(int i=0; i < objChargeInfoArry.size(); i++){
							objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
							strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
							strCdNm = (String)objChargeInfoHt.get("CD_NM");
							
							strChecked = "";
							strDisabled = "";
							strRemark = "";
							for(int k=0; k < objUserChargeArry.size(); k++){
								objUserChargeHt = (Hashtable)objUserChargeArry.get(k);
								strType = (String)objUserChargeHt.get("CHARGE_TYPE");
								strCharge = (String)objUserChargeHt.get("CHARGE_CD");
								strRemark = (String)objUserChargeHt.get("REMARK");
								if(strType.equals("M")){
									if(strCharge.equals(strMsortCd) && !strMsortCd.equals("999")){
										strDisabled = "disabled";
										break;
									}
									continue;
								}
								if(strCharge.equals(strMsortCd)){
									strChecked = "checked";
									break;
								}
							}
							
							if(strType.equals("M"))
								strRemark="";

							if( strMsortCd.equals("999")){
						%>

												<input name="schr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%> onclick="makeTextBox(this,'SRK')" class=" borderNo"><%=strCdNm%>&nbsp;&nbsp;<BR>
												<SPAN id="SRK"><input name="SRK" value="<%=strRemark%>"  class='textfield' style='WIDTH: 200px' maxlength=15>&nbsp;&nbsp;</SPAN>
						<%
									}else{
						%>
												<input name="schr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> onclick="fun_checkm(this)" class=" borderNo"><%=strCdNm%>&nbsp;&nbsp;

						<%
									}
								}
						%>
						</td>

                </tr>				
				<%
				}	
				%>
				<%
					String strRepFlag = (String)objHshReqUserInfo.get("REP_FLAG");
					if(strInOutGbn.equals("X")){
						if(strRepFlag == null)
							strRepFlag = "N";
				%>

                <tr>

                    <th height="25" colspan="2" align="middle">��ǥ��   ����<span class="warning">*</span></th>

                    <td height="25"><input value="Y" <%=strRepFlag.equals("Y")?"checked":""%> type="radio" name="REP_FLAG" class=" borderNo" />

                        ��ǥ��

                        <input type="radio" name="REP_FLAG" value="N" <%=strRepFlag.equals("N")?"checked":""%>  class=" borderNo"/>

                        �Ϲ�</td>

                </tr>
				<% 
					}else{
				%>
				<input type="hidden" name="REP_FLAG">
				<%}%>
				<%
					String strPhoto =  StringUtil.getNVLNULL( (String)objHshReqUserInfo.get("PHOTO_PATH")); //���� ������
 				%>

                <tr>

                    <th height="25" colspan="2">�������</th>

                    <td onmouseover="showtip(this,event,'����ũ��:��������(���� 5cm * ���� 4cm )')" title="����ũ��:��������(���� 5cm * ���� 4cm )" onmouseout="hidetip()" height="25" colspan="2">
					<input name="PHOTO_PATH" type="hidden" style="WIDTH: 220px" VALUE=<%=objHshReqUserInfo.get("PHOTO_PATH")%>>
					<input name="selFileShow" type="text" class="textfield" style="WIDTH: 170px" VALUE="<%=objHshReqUserInfo.get("PHOTO_PATH")%>" readonly>
					<input name="selFile" type="file" class="textfield" style="WIDTH:0px" VALUE="<%=objHshReqUserInfo.get("PHOTO_PATH")%>" onChange="javascript:showImageFile('selFile', 'selFileShow');">
				&nbsp<a href="javascript:fun_view(document.frmJoinMember);"><img src="/image/button/bt_preview_icon.gif" width="71" height="19" align="absmiddle" border=0></a></td>

                </tr>

                <tr>

                    <th height="65" colspan="2">�ڱ�Ұ�</th>

                    <td height="65" colspan="2"><textarea wrap="hard" name="REMARK" style="width:400px; height:65px;"><%=objHshReqUserInfo.get("REMARK")%>
</textarea>
					</td>

                </tr>

            </table>

            <!-- /list -->

            <div id="btn_all" class="t_right"> <span class="list_bt"><a href="#" onclick="checkValidation(document.frmJoinMember);">Ȯ ��</a></span> <span class="list_bt"><a href="#" onclick="window.location='/index.html'">�� ��</a></span> </div>

            

            <!-- /����Ʈ ��ư--> 

            

            <span class="warning"> (*) ǥ�ô� �ʼ� �׸� �Դϴ�.</span> </div>

    </div>

    <div id="log_footer"> <span class="copy" ><img src="/images2/login/copyright.gif" width="448" height="26" /></span></div>

</div>
<input type=hidden name="STT_CD" VALUE="001">
<input type=hidden name="STT_CHG_RSN" VALUE="ȸ������ ��û�� ���������� ���ƽ��ϴ�.">
<input type=hidden name="USER_GRP_ID" VALUE="<%=strUserGrpId%>">
<input type=hidden name="SRCH_RECORD_CNT" VALUE="<%=strSrchRecordCnt%>">
<input type=hidden name="SRCH_DISPLAY_KIND" VALUE="<%=strSrchDisplayKind%>">
<input type=hidden name="GTHER_PERIOD" VALUE="<%=strGtherPeriod%>">
<input type=hidden name="CG_DUTY">
</form>
</body>

</html>