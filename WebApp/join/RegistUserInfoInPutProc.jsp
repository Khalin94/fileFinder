<%@ page contentType="text/html;charset=euc-kr" %>

<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="kr.co.kcc.bf.log.Log" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.*" %>
<%@ page import="java.text.*" %>
<%@ page import="nads.dsdm.app.common.ums.UmsInfoDelegate" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>



<%
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Pragma","no-cache"); 
	response.setDateHeader("Expires",0);

	String webPath = ""; 
	String imgPath = ""; 

	String strSchrWord = ""; 
	String strMchrWord = ""; 
	String username = "";
	String eventdate  = "";
	String organid = "";

//	String in_symm_enckey = "";
	String in_username = "";
	String in_eventdate = "";

	byte[] bt_username = null;
	byte[] bt_eventdate = null;
	

	MultipartRequest multi=null;

	String realDate = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
	String fileKind = "";

	String strMessage = "";
	nads.dsdm.app.activity.userinfo.UserInfoDelegate objUserInfoDelegate = new nads.dsdm.app.activity.userinfo.UserInfoDelegate();
	ArrayList objChargeInfoArry = new ArrayList();
	String strError = "no";	

	nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate ();
	UmsInfoDelegate objUmsDelegate = new UmsInfoDelegate();

	Hashtable objUserInfoHt = null;
	Hashtable hashSmsInfo = new Hashtable();
	String strSendPhoneNo = null;
	String strReturnPhoneNo=null;
	String strSmsMsg=null;
	String strSystemGbn="S13002";

	String strServiceGbn="003";
	String strOrganId=null;
	String strUserID="";
	String strOrganNm=null;
	String strName=null;
	String strImgPath = "";
	String strFullPath = "";
	String strSFlag = "";

	try{
	
		Config objConfig = PropertyConfig.getInstance();

		webPath = objConfig.get("nads.dsdm.webapp.path");
		imgPath = objConfig.get("user.photo.path");
		
		strImgPath = webPath + imgPath;
		strFullPath = webPath + imgPath;
		File objDir = new File(strImgPath); 
		
		if(!objDir.exists()){
			objDir.mkdirs();
		}
	
		int intSizeLimit = 1000 * 1024 ;

		multi=new MultipartRequest(request, strImgPath, intSizeLimit, "euc-kr", new DefaultFileRenamePolicy());	
		
		objChargeInfoArry = objUserInfoDelegate.selectChargeCdInfo();
		
//		in_symm_enckey = multi.getParameter("symm_enckey");
		username = multi.getParameter("USER_NM");
		eventdate = multi.getParameter("eventdate");
		organid = multi.getParameter("ORGAN_ID");
		strSFlag = StringUtil.getNVLNULL(multi.getParameter("SFLAG"));

		
		
		
/*		
		if (in_symm_enckey != null){
			System.out.println("ksign");
			///////////////////////////////////////////////////// START

			System.out.println("��ȣȭ�� Ű��  : " + in_symm_enckey );
			System.out.println("------------------------------------------------------------------------------<BR>");

			JCEUtil.initProvider();

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
			bt_eventdate = symmdecrypt.SymmDecrypt(in_eventdate, key, "SEED");

			eventdate = new String(bt_eventdate);

			System.out.println("������ Ű�� : " + key );

		}
*/
		
		
	}catch(Exception objConfigEx){
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}	
%>

<%
	try{
		java.util.Hashtable objHshReqUserInfo2 = new java.util.Hashtable();
		java.util.Hashtable objHshParam = new java.util.Hashtable();

		if(eventdate != null && !eventdate.equals("")){			
			objHshParam.put("username",username);
			objHshParam.put("eventdate",eventdate.substring(2,8));
			objHshParam.put("organid",organid);
			objHshReqUserInfo2 = objJoinMemberDelegate.getUserInfo2(objHshParam);
			System.out.println("STTCD : : : : :  : "+objHshReqUserInfo2.get("STT_CD"));
			if(objHshReqUserInfo2.get("STT_CD") != null){
				if(objHshReqUserInfo2.get("STT_CD").equals("001")){
					out.println("<script> alert('�̹� �����ϼ̽��ϴ�.�α����ϼż� ����Ͻʽÿ�.'); document.location = '/index.html';</script>");
					return;
				}else if(objHshReqUserInfo2.get("STT_CD").equals("002")){
					out.println("<script> alert('������������Դϴ�. �����ڿ��� �����Ͻʽÿ�.'); document.location = '/index.html';</script>");
					return;
				}else if(objHshReqUserInfo2.get("STT_CD").equals("003")){
					out.println("<script> alert('Ż�� ������Դϴ�. �����ڿ��� �����Ͻʽÿ�.'); document.location = '/index.html';</script>");
					return;
				}else if(objHshReqUserInfo2.get("STT_CD").equals("005")){
					out.println("<script> alert('���Դ�����Դϴ� ���� �������� �̵��մϴ�.'); document.location = '/index.html';</script>");
					return;
				}else if(objHshReqUserInfo2.get("STT_CD").equals("006")){
					out.println("<script> alert('���Խ��� �����Դϴ�. [����� ��� Ȯ��]�� �̿��Ͽ� ����� �Ϸ��Ͻʽÿ�'); document.location = '/join/RegistUserTerms.jsp';</script>");
					return;
				}else if(objHshReqUserInfo2.get("STT_CD").equals("007")){
					out.println("<script> alert('�����ڰ� ��û�� �ݷ��Ͽ����ϴ�. �����ڿ��� �����Ͻʽÿ�.'); document.location = '/index.html';</script>");
					return;
				}			
			}			
		}					
	}catch(Exception objExcept)
	{	
		System.out.println("Error!!!" + objExcept.getMessage());
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
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
<script language="javascript">

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
<body>
<div id="log_wrap">
    <div class="login">
        <h1><img src="/images2/login/logo02.gif" width="194" height="46" /></h1>
        <div class="user_con"> <br />
            <br />
			<!-- list -->
			<form action="/join/PreJoinMemberProc.jsp" method="post" name="frmPreJoinMember">
            <span class="list02_tl">����� ���� �Է�</span> <span class="list_total">(*) ǥ�ô� �ʼ� �׸� �Դϴ�.</span>
            <table border="0" cellspacing="0" cellpadding="0" class="list03" >
                <tr>
                    <th width="18%" rowspan="3" align="middle" valign="top"><img src="/images2/foundation/pic.gif" width="110" height="120" class="pic" /></th>
                    <th width="85" align="middle">����<span class="warning">*</span></th>
                    <td ><%=username%><input name="USER_NM" type="hidden" value="<%=username%>"></td>
                </tr>				
                <tr>
                    <th align="middle">�������</th>
                    <td height="25">
					<%=eventdate.substring(0,4)%>��&nbsp;<%=eventdate.substring(4,6)%>��&nbsp;<%=eventdate.substring(6,8)%>��
					<%
						String tempevent = eventdate.substring(0,4)+"�� "+eventdate.substring(4,6)+"�� "+eventdate.substring(6,8)+"��";
					%>
					<input type=hidden name="JUMIN_NO1" VALUE="<%=tempevent%>">
					<input type=hidden name="eventdate" value="<%=eventdate%>">
					</td>
                </tr>                
                <tr>
                    <th align="middle">�����<span class="warning">*</span></th>
                    <td height="25"><input name="ORGAN_NM" type="text" class="textfield" style="WIDTH: 220px" readonly / b /> 
					<input name="ORGAN_ID" type="hidden" > 
					<input name="ORGAN_NO" type="hidden" > 
					<input name="HOME_URL" type="hidden" > 
					<input name="ORGAN_JUSO1" type="hidden" > 
					<input name="ORGAN_JUSO2" type="hidden" > 
					<input name="organid" type="hidden" > 
					<span class="list_bt"><a href="#" onclick="winopen('/join/SearchOrgPop.jsp','SearchOrgPop','height=400,width=520,scrollbars=yes,resize=yes')" >ã ��</a>
                  </td>
                </tr>
                <tr>
                    <th colspan="2" align="middle" valign="top">�μ���</th>
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
                    <th rowspan="3" align="middle" class="fonts">��ȭ��ȣ</th>
					<input type=hidden name="OFFICE_TEL" >
                    <th height="25" class="fonts" >�繫��<span class="warning">*</span></th>
                    <td height="25" colspan="2"><input maxlength="4" name="OFFICE_TEL1" style="width:30px" />
                        -
                        <input maxlength="4" name="OFFICE_TEL2" style="width:30px"/>
                        -
                        <input maxlength="4" name="OFFICE_TEL3" style="width:55px"/></td>
                </tr>
                <input value="0081" maxlength="4" type="hidden" name="innerphone" />
                <tr>
                    <th height="25" class="fonts"  >FAX<span class="warning">*</span></th>
					<input type=hidden name="FAX_NO" >
                    <td height="25" colspan="2"><input maxlength="4" name="FAX_NO1" style="width:30px" />
                        -
                        <input maxlength="4" name="FAX_NO2" style="width:30px"/>
                        -
                        <input maxlength="4" name="FAX_NO3" style="width:55px"/></td>
                </tr>
				<% 
					String strCphone = "";
					String strCphone1 = "";
					String strCphone2 = "";
					String strCphone3 = "";				
				%>
                <tr>
                    <th height="25" class="fonts" >�̵���Ź�ȣ<span class="warning">*</span></th>
					<input name="CPHONE" type="hidden" style="width:45px">
                    <td height="25" colspan="2"><select name="CPHONE1" style="width:45px">
                            <option <%=strCphone1.equals("010")?"selected":""%> value="010">010</option>
							<option <%=strCphone1.equals("016")?"selected":""%> value="016">016</option>
							<option <%=strCphone1.equals("017")?"selected":""%> value="017">017</option>
							<option <%=strCphone1.equals("018")?"selected":""%> value="018">018</option>
							<option <%=strCphone1.equals("019")?"selected":""%> value="019">019</option>
							<option <%=strCphone1.equals("011")?"selected":""%> value="011">011</option>
                        </select>
                        -
                        <input maxlength="4" name="CPHONE2" style="width:30px" />
                        -
                        <input maxlength="4" name="CPHONE3" style="width:40px" /></td>
                </tr>
                <tr>
                    <th rowspan="3" align="middle" >�ٹ���</th>
                    <th align="middle" class="fonts" >�����ȣ</th>
                    <td height="25" colspan="4"><input name="POST_CD" type="hidden"/>
					<input maxlength="7" name="POST_CD1" readonly style="width:60px"/>
                        &nbsp;<span class="list_bts"><a href="#" onclick="winopen('/common/SearchZipCodePop.jsp','SearchZipCodePop','height=450,width=520,scrollbars=yes,resize=yes')">�����ȣ�˻�</a></span></td>
                </tr>
                <tr>
                    <th align="middle" class="fonts" >�⺻�ּ�</th>
                    <td height="25"><input maxlength="100" name="JUSO1" readonly  style="width:350px;"/></td>
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
						
						Hashtable objChargeInfoHt = new Hashtable();
				
						for(int i=0; i < objChargeInfoArry.size(); i++){
							objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
							strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
							strCdNm = (String)objChargeInfoHt.get("CD_NM");	
							
							if(multi.getParameter("mchr"+i) != null) {
								strChecked = "checked";
								if(!strMsortCd.equals("999")) {
									strMchrWord = strMchrWord + " " + strCdNm;
								}
							}
				
							if(strMsortCd.equals("999")){
					%>
								<input name="mchr<%=Integer.toString(i)%>" type='checkbox' value="<%=strMsortCd%>"  <%=strChecked%> disabled onclick="makeTextBox(this,'mainJob')"><%=strCdNm%>&nbsp;&nbsp;
					<%
							
							}else{
					%>
								<input name="mchr<%=Integer.toString(i)%>" type='checkbox' value="<%=strMsortCd%>"  <%=strChecked%> disabled onclick="fun_checkm(this)"><%=strCdNm%>&nbsp;&nbsp;									
					<%
							}
							strChecked = "";
						}
					%>                      
						<DIV ID="mainJob" ></DIV>
						<input type='text' name='MRK'  style='WIDTH: 300px' maxlength=25 >
						<input type='hidden' name='MchrWord' style='WIDTH: 300px' maxlength=25>
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
							
						
							if(multi.getParameter("schr"+i) != null) {
								strChecked = "checked"; 
				
								if(!strMsortCd.equals("999")) {
									strSchrWord = strSchrWord + " " + strCdNm;
								}
							}
				
							if(strMsortCd.equals("999")){				
					  %>
										<input name="schr<%=Integer.toString(i)%>" type='checkbox' value="<%=strMsortCd%>"  <%=strChecked%> disabled onclick="makeTextBox(this,'subJob')"><%=strCdNm%>&nbsp;&nbsp;
					  <%
					
							}else{
					  %>
										<input name="schr<%=Integer.toString(i)%>" type='checkbox' value="<%=strMsortCd%>"  <%=strChecked%> disabled onclick="fun_checkm(this)"><%=strCdNm%>&nbsp;&nbsp;					
					  <%
							}
							strChecked = "";
						}
					%>  
						<DIV ID="subJob"></DIV>
						<input type='text' name='SRK' class='textfield' style='WIDTH: 300px' maxlength=25 >
						<input type='hidden' name='SchrWord' class='textfield' style='WIDTH: 300px' maxlength=25>	
					</td>
                </tr>
				<%
					String strRepFlag = multi.getParameter("REP_FLAG");
				%>
                <tr>
                    <th height="25" colspan="2" align="middle">��ǥ��   ����<span class="warning">*</span></th>
                    <td height="25"><input value="Y" <%=strRepFlag.equals("Y")?"checked":""%> type="radio" name="REP_FLAG" class=" borderNo" />
                        ��ǥ��
                        <input type="radio" name="REP_FLAG" value="N" <%=strRepFlag.equals("N")?"checked":""%>  class="borderNo"/>
                        �Ϲ�</td>
                </tr>
                <tr>
                    <th height="25" colspan="2">�������</th>
                    <td height="25" colspan="2">
					<input name="PHOTO_PATH" type="text" class="textfield" style="WIDTH: 220px" >
					<input name="selFileShow" type="hidden" class="textfield" style="WIDTH: 220px">
					</td>
                </tr>
                <tr>
                    <th height="65" colspan="2">�ڱ�Ұ�</th>
                    <td height="65" colspan="2"><textarea wrap="hard" name="REMARK" style="width:400px; height:65px;"></textarea></td>
                </tr>
            </table>
			</div>
			<!-- /list -->
            <div id="btn_all" class="t_right"> <span class="list_bt"><a href="#" onclick="javascript:printUserInfo('N')" >�� ��</a></span> <span class="list_bt"><a href="#" onclick="javascript:returntomain();">�� ��</a></span> </div>
            
            <!-- /����Ʈ ��ư--> 
            <span class="warning"> (*) ǥ�ô� �ʼ� �׸� �Դϴ�.</span> </div>
    </div>
    <div id="log_footer"> <span class="copy" ><img src="/images2/login/copyright.gif" width="448" height="26" /></span></div>
</div>
<input type=hidden name="USER_KIND" VALUE="999">
<input type=hidden name="STT_CD" VALUE="005">
<input type=hidden name="STT_CHG_RSN" VALUE="������û�� �ϼ̽��ϴ�.">
<input type=hidden name="USER_GRP_ID" >
<input type=hidden name="SRCH_RECORD_CNT" >
<input type=hidden name="SRCH_DISPLAY_KIND" >
<input type=hidden name="GTHER_PERIOD" >
<input type=hidden name="GRD_CD">
<input type=hidden name="CG_DUTY">
<input type=hidden name="ORG_POSI_GBN" >
<input type=hidden name="REQ_SUBMT_FLAG" >
<input type=hidden name="SFLAG" >

</form>
<%
	Enumeration formNames = multi.getFileNames();
	String strFormName=(String)formNames.nextElement();	
	String strFileName = multi.getFilesystemName(strFormName);
	String strOrgName = multi.getOriginalFileName(strFormName);
	File objFile = multi.getFile(strFormName);
	
	if(strFileName == null) {   
	
		Log.debug.print("���� ���ε� ���� �ʾ���");
		
	} else {  
		strImgPath = imgPath+strFileName;

		if(strFileName.lastIndexOf(".") > 0) {
			fileKind = strFileName.substring(strFileName.lastIndexOf("."));
		}

		File uploadImg = new File(strFullPath,strFileName);
		File renameImg = new File(strFullPath,realDate+fileKind);

		if(uploadImg.renameTo(renameImg) == true) {
			strImgPath = imgPath + renameImg.getName();
		}		
	}
	


	
	Enumeration objEnuNames = multi.getParameterNames();
	String strParamName = "";
	java.util.Hashtable objHshReqUserInfo = new java.util.Hashtable();
	Vector objVctMain = new Vector();
	Vector objVctSub = new Vector();

	out.println("<script language='javascript'>");
	for(int i =0;objEnuNames.hasMoreElements() ;){
		strParamName = (String)objEnuNames.nextElement();
		Log.debug.println(strParamName+":"+multi.getParameter(strParamName));
		
		if(strParamName.indexOf("mchr") > -1 )
		{
			System.out.println("strParamName main===========>"+multi.getParameter(strParamName));
			objVctMain.add(	multi.getParameter(strParamName));

		}else if(strParamName.indexOf("schr") > -1 )
		{
			System.out.println("strParamName sub===========>"+multi.getParameter(strParamName));
			objVctSub.add(	multi.getParameter(strParamName));

		}else {
			objHshReqUserInfo.put(strParamName,multi.getParameter(strParamName));
		}

		if(strParamName.equals("x") || strParamName.equals("y") )
			continue;
		
		out.println("document.frmPreJoinMember."+strParamName+".value='"+multi.getParameter(strParamName)+"';");
	}
			
	objHshReqUserInfo.put("M",objVctMain);
	objHshReqUserInfo.put("S",objVctSub);

	if(strFileName != null){
		objHshReqUserInfo.put("PHOTO_PATH",strImgPath);
		out.println("document.frmPreJoinMember.PHOTO_PATH.value='"+realDate+fileKind+"'");
	}

	out.println("document.frmPreJoinMember.MchrWord.value='"+strMchrWord+"' + ' ' + document.frmPreJoinMember.MRK.value;");
	out.println("document.frmPreJoinMember.SchrWord.value='"+strSchrWord+"' + ' ' + document.frmPreJoinMember.SRK.value;");

	out.println("</script>");
	Log.debug.println("===>"+imgPath+strFileName);
	System.out.println("eventeate : "+eventdate.substring(2,8));
	objHshReqUserInfo.put("eventdate",eventdate.substring(2,8));
	

	try{	
		String strResult = (String)objJoinMemberDelegate.preJoinMember2(objHshReqUserInfo); 
		//1.TBDM_USER_INFO�� �μ�Ʈ �� 2. ����ں� �����������̺�(tbdm_user_itet)�� ����Ʈ�� ����
   	    //3. �ҼӺμ�(tbdm_brg_dept) ���� 4. ������(tbdm_user_charge)
   	    
		System.out.println("RESULT_ID : " +strResult);

		objUserInfoHt = objJoinMemberDelegate.getUserInfo("ADMIN");
		strSendPhoneNo = nads.lib.reqsubmit.util.StringUtil.ReplaceString((String)objUserInfoHt.get("CPHONE"), "-", "");
		strReturnPhoneNo = multi.getParameter("CPHONE1")+multi.getParameter("CPHONE2")+multi.getParameter("CPHONE3");
		strOrganId = multi.getParameter("ORGAN_ID");
		strOrganNm = multi.getParameter("ORGAN_NM");
		strName = multi.getParameter("USER_NM");
		if(strSFlag.equals("Y")){
			strSmsMsg = "["+strOrganNm+"] "+ strName +"���� ��� �� ���Խ�û ��û�Դϴ�.";
		}else{
			strSmsMsg = strName +"���� [�����ڷ� �������� �ý���] ���Խ�û ��û�Դϴ�.";
		}
		


		int intSmsSendResult = 0;

		System.out.println("SEND_PHONE_NO : " +strSendPhoneNo);
		System.out.println("RETURN_NO : " +strReturnPhoneNo);
		System.out.println("MSG : " +strSmsMsg);
		System.out.println("SYSTEM_GBN : " +strSystemGbn);
		System.out.println("SERVICE_GBN : " +strServiceGbn);
		System.out.println("DEPT_GBN : " +strOrganId);
		System.out.println("USER_ID : " +strResult);
		System.out.println("DEPT_NM : " +strOrganNm);
		System.out.println("USER_NM : " +strName);


		hashSmsInfo.put("SEND_PHONE_NO", strSendPhoneNo);
		hashSmsInfo.put("RETURN_NO", strReturnPhoneNo);
		hashSmsInfo.put("SEND_STATUS", "1"); 
		hashSmsInfo.put("MSG", strSmsMsg);
		hashSmsInfo.put("SYSTEM_GBN", strSystemGbn);
		hashSmsInfo.put("SERVICE_GBN", strServiceGbn);
		hashSmsInfo.put("DEPT_GBN", strOrganId);
		hashSmsInfo.put("USER_ID", strResult);
		hashSmsInfo.put("DEPT_NM", strOrganNm); 
		hashSmsInfo.put("USER_NM", strName); 

		intSmsSendResult = objUmsDelegate.insertSMS(hashSmsInfo);

		if (intSmsSendResult < 1) System.out.println("[RMakeReqDocSendProc.jsp] SMS �߼� ��� ����� ���⼭ ������ �߻��߽��ϴ�. T_T");

		if(strResult != null && !strResult.equals("")){
			out.println("<script>alert('���Խ�û�� �Ϸ� �Ǿ����ϴ�. �ϴ��� �μ��ư�� �̿����ּ���.\\n[���Խ�û���� ����� ���ΰ� �Բ� FAX : 02-788-3378�� �����ֽñ� �ٶ��ϴ�.]');</script>");
		}
	}catch(Exception objExcept){	

		strMessage = strMessage + "[���ܹ߻�]" + objExcept.toString();
		String strErrCode = ((AppException)objExcept).getStrErrCode();

		Log.debug.println(strMessage);

		if(strErrCode.equals("ORA-00001")){
			out.println("<script>alert('�����ڰ� ����ó���� �������Դϴ�'); document.location = '/index.html';</script>");
		}else{
%>
			<jsp:forward page='/common/message/ViewMsg.jsp'/>
<%			
			return;
		}
	}
%>
<script Language="Javascript">
	function printUserInfo(type){
	
	if(type == "Y")
		winopen('/join/PrintUserInfo4Cert.jsp','PrintUserInfo','height=550,width=650,scrollbars=yes,resize=yes');
	else
		winopen('/join/PrintUserInfo2.jsp?SFLAG=<%=strSFlag%>','PrintUserInfo','height=550,width=650,scrollbars=yes,resize=yes');

	}
	
	function returntomain(){
		
		alert('���Խ�û�� ���� �μ��ư�� �����ּ���.');
		window.location='/index.html';

	}
</script>
</body>
</html>