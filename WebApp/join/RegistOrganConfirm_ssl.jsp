<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ksign.jce.util.*"%>
<%@ page import="ksign.jce.sample.*"%>

<%

	String username = "";
	String eventdate = "";
	String call = "";

	String next_location = "";

	String in_symm_enckey = "";
	String in_username = "";
	String in_eventdate = "";

	byte[] org_username = null;
	byte[] org_eventdate = null;
	
	in_symm_enckey = request.getParameter("symm_enckey");
	in_username = request.getParameter("username");
	in_eventdate = request.getParameter("eventdate");

	java.util.Hashtable objHshParam = new java.util.Hashtable();
	java.util.Hashtable objHshReqUserInfo = new java.util.Hashtable();





	if (in_symm_enckey != null)
	{

		///////////////////////////////////////////////////// START
		System.out.println("<b>��ȣȭ��</b><br><b>Ű ��  :</b><br>&nbsp;" + in_symm_enckey + "<BR>");
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
			String passwd = "dlswmdrhksfl11";
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
			//byte[] org_regsid1 = symmdecrypt.SymmDecrypt(in_regsid1, key, "SEED");//����Ű�� ���� ��ȣȭ
			//byte[] org_regsid2 = symmdecrypt.SymmDecrypt(in_regsid2, key, "SEED");

			org_username = symmdecrypt.SymmDecrypt(in_username, key, "SEED");

			org_eventdate = symmdecrypt.SymmDecrypt(in_eventdate, key, "SEED");


			System.out.println("<b>������</b><br><b>Ű�� :</b><br>&nbsp;" + key + "<BR>");

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e.toString());
			System.out.println("error1 :  " + e.toString());
			System.out.println("error2 : " + JCEUtil.getErrormsg());
			System.out.println("error3 : " + JCEUtil.getErrorcode());
		}
		///////////////////////////////////////////////////// END

		username = new String(org_username);
		eventdate = new String(org_eventdate);

	}

	

	try{

		if(org_eventdate != null && !org_eventdate.equals("")){
			nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();
			//objHshParam.put("CERT_DN","");
			//objHshParam.put("JUMIN_NO",resid_no);
			
			objHshParam.put("username",username);
			objHshParam.put("eventdate",eventdate.substring(2,8));
			objHshParam.put("empNo","");

			objHshReqUserInfo = objJoinMemberDelegate.getUserInfo3(objHshParam);

			//System.out.println("STT_CD : "+java.net.URLEncoder.encode(EncData));

			if(objHshReqUserInfo.get("STT_CD") == null || objHshReqUserInfo.get("STT_CD").equals("000")){
				//out.println("<script>document.location = '/join/RegistOrganInfoInPut.jsp?symm_enckey="+in_symm_enckey+"'</script>");
				next_location = "OK";

//				out.println(next_location);
				System.out.println(next_location);

			}else if(objHshReqUserInfo.get("STT_CD").equals("001")){
				out.println("<script> alert('�űԻ���ڸ� ��û�ϽǼ� �ֽ��ϴ�.'); document.location = '/index.html';</script>");
			}else if(objHshReqUserInfo.get("STT_CD").equals("002")){
				out.println("<script> alert('������������Դϴ�. �����ڿ��� �����Ͻʽÿ�.'); document.location = '/index.html';</script>");
			}else if(objHshReqUserInfo.get("STT_CD").equals("003")){
				out.println("<script> alert('Ż�� ������Դϴ�. �����ڿ��� �����Ͻʽÿ�.'); document.location = '/index.html';</script>");
			}else if(objHshReqUserInfo.get("STT_CD").equals("005")){
				out.println("<script> alert('�űԻ���ڸ� ��û�ϽǼ� �ֽ��ϴ�.'); document.location = '/index.html';</script>");
			}else if(objHshReqUserInfo.get("STT_CD").equals("006")){
				out.println("<script> alert('�űԻ���ڸ� ��û�ϽǼ� �ֽ��ϴ�.'); document.location = '/index.html';</script>");
			}else if(objHshReqUserInfo.get("STT_CD").equals("007")){
				out.println("<script> alert('�����ڰ� ��û�� �ݷ��Ͽ����ϴ�. �����ڿ��� �����Ͻʽÿ�.'); document.location = '/index.html';</script>");
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


<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta http-equiv="Page-Enter" content="blendTrans(Duration=.01)" />
<meta http-equiv="Page-Exit" content="blendTrans(Duration=.01)" />

<link type="text/css" rel="stylesheet" href="/jquery-1.10.4/css/smoothness/jquery-ui-1.10.4.custom.css" >
<script type="text/javascript" src="/jquery-1.10.4/js/jquery-1.10.2.js"></script>
<script type="text/javascript" src="/jquery-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>
<script src="/js/common.js"></script>
<script src="/js/validate.js" ></script>
<script src="/js/activity.js"></script>
<script type='text/javascript' src='/javascript/CKKeyPro_nosign.js'></script>


<script type="text/javascript">
	function funView(){
		var form = document.NAPS;

		if(form.eventdate.value == ""){
			alert('��������� �Է��� �ֽʽÿ�');
			form.eventdate.focus();
			return;
		}else if(form.username.value == ""){
			alert('������ �Է��� �ֽʽÿ�');
			form.username.focus();
			return;
		}else{
			//form.action = "RegistOrganConfirm.jsp";
			form.action = "https://naps.assembly.go.kr/join/RegistOrganConfirm_ssl.jsp";
                        alert('kangthis logs action => ' + form.action);
			//encryptForm(form); //penta
			GenSymmKey(form)
			return;		
		}						
	}

	function funEnterCheck() {
   		if(event.keyCode == 13 ) {
      		funView(1);
   		}
	}
	

	$(function() {
	  
	  $( "#eventdate").datepicker({
		  showOn: "both", // ��ư�� �ؽ�Ʈ �ʵ� ��� Ķ������ �����ش�.
		  buttonImage: "/images2/btn/bt_calender.gif", // ��ư �̹���
		  buttonImageOnly: true, // ��ư�� �ִ� �̹����� ǥ���Ѵ�.
		  changeMonth: true, // ���� �ٲܼ� �ִ� ����Ʈ �ڽ��� ǥ���Ѵ�.
		  changeYear: true, // ���� �ٲ� �� �ִ� ����Ʈ �ڽ��� ǥ���Ѵ�.
		  minDate: '-100y', // ���糯¥�κ��� 100���������� ���� ǥ���Ѵ�.
		  nextText: '���� ��', // next �������� ����.
		  prevText: '���� ��', // prev �������� ����.
		  yearRange: 'c-70:c+0', // �⵵ ���� ����Ʈ�ڽ��� ���� �⵵���� ����, ���ķ� ���� ������ ǥ���Ұ��ΰ�.
		  showButtonPanel: true, // Ķ���� �ϴܿ� ��ư �г��� ǥ���Ѵ�. 
		  currentText: '���� ��¥' , // ���� ��¥�� �̵��ϴ� ��ư �г�
		  closeText: '�ݱ�',  // �ݱ� ��ư �г�
		  dateFormat: "yymmdd", // �ؽ�Ʈ �ʵ忡 �ԷµǴ� ��¥ ����.
		  showAnim: "slide", //�ִϸ��̼��� �����Ѵ�.
		  showMonthAfterYear: true , // ��, ����� ����Ʈ �ڽ��� ��,�� ������ �ٲ��ش�. 
		  dayNamesMin: ['��', 'ȭ', '��', '��', '��', '��', '��'], // ������ �ѱ� ����.
		  monthNamesShort: ['1��','2��','3��','4��','5��','6��','7��','8��','9��','10��','11��','12��'] // ���� �ѱ� ����.
	  });

	});

	function MM_openBrWindow3(theURL,winName,features)
	{
		var winl = (screen.width - 800) / 2;
		var wint = (screen.height - 920) / 2;
		var winProp='width=800,height=920,scrollbars=yes, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no,top=' + wint + ',left=' + winl;
		window.open(theURL, winName, winProp);
	}



</script>


<SCRIPT LANGUAGE="JavaScript">
<!--
var isNN = (navigator.appName.indexOf("Netscape")!=-1);

function autoTab(input,len, e) {
        var keyCode = (isNN) ? e.which : e.keyCode;
        var filter = (isNN) ? [0,8,9] : [0,8,9,16,17,18,37,38,39,40,46];
        if(input.value.length >= len && !containsElement(filter,keyCode)) {
        input.value = input.value.slice(0, len);
        input.form[(getIndex(input)+1) % input.form.length].focus();
}

function containsElement(arr, ele) {
        var found = false, index = 0;
        while(!found && index < arr.length)
        if(arr[index] == ele)
        found = true;
        else
        index++;
        return found;
}

function getIndex(input) {
        var index = -1, i = 0, found = false;
        while (i < input.form.length && index == -1)
        if (input.form[i] == input)index = i;
        else i++;
        return index;
        }
return true;
}

// -->
</script>

<link type="text/css" href="/css2/style.css" rel="stylesheet">


</head>

<body>

<form name="NAPS" method="post">
<input type="hidden" name="symm_enckey" id="symm_enckey" />


<div id="log_wrap">
    <div class="login">
        <h1><img src="/images2/login/logo02.gif" width="194" height="46" /></h1>
        <div class="user_con"> <br />
            <br />
            <div class="schBox" >
                <p>�������� Ȯ��</p>
                <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
                <div class="box">
                    <!-- ������ �˻� ����Ʈ�� ��ư�� ��������-->
                    <table width="600px" border="0" cellspacing="3" cellpadding="0">  
						<tr>
                            <td>&bull;&nbsp;<strong>�������</strong></td>
                            <td><input type="text"   name="eventdate" id="eventdate" value='' style="WIDTH:70px;" maxlength="8" readonly />
										
							
							</td>
							<td></td>
                        </tr>
						<tr>
                            <td>&bull;&nbsp;<strong>����</strong></td>
                            <td><input type="text"  name="username" id="username" />
										
							
							</td>
							<td></td>
                        </tr>                        
                    </table>
                </div>
            </div>
            <div id="btn_all" class="t_right"> <span class="list_bt"><a href="javascript:funView();">Ȯ ��</a></span> <span class="list_bt"><a href="#" onclick="window.location='/index.html'">�� ��</a></span> </div>

            <!-- /����Ʈ ��ư-->
            <span class="warning">������� �� ���� �Է½� Ű���� ���Ƚý����� �۵� �˴ϴ�. </span> </div>
    </div>
    <div id="log_footer"> <span class="copy" ><a href="javascript:MM_openBrWindow3('http://naps.assembly.go.kr/persnalinfo.htm','','width=600,height=520')"><img src="/images2/login/movie_04_con4.gif"/></a><img src="/images2/login/copyright.gif" width="448" height="26" /></span></div>
</div>

<script language="javascript" src="/axkcase.js"></script>

</form>

</body>
</html>


<!-- jscript.js -->
<script type="text/javascript">
	function CheckAX() {
		var installed = false;
		try {
			xObj = new ActiveXObject("AxNAROKPPD.AxNAROKPPD.1");
			if (xObj)
				installed = true;
			else
				installed = false;
		} catch (ex) {
			installed = false;
		}
		return installed;
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////
	// ENC
	var key;
	function GenSymmKey(form) {
		var retValue_1;
		var retValue_2;
		// ����Ű���� ���� s
		form.symm_enckey.value = document.CKKeyPro.GetEncData("CN=SVR9710000001,OU=Group of Server,O=Government of Korea,C=KR", "", "");

		for(i=0; i< form.length; i++)
		{

				if(form.elements[i].name == "eventdate"){

					retValue_1 = document.CKKeyPro.GetEncData("",form.name, form.elements[i].name);
					form.eventdate.value = retValue_1;
				}
				if(form.elements[i].name == "username"){

					retValue_2 = document.CKKeyPro.GetEncData("",form.name, form.elements[i].name);
					form.username.value = retValue_2;
				}
		}

		form.submit();
	}
</script>

<object id="AxKCASE"  classid="CLSID:49E90C74-4A36-469d-91F8-2BBDE9E6EAAD"
	codebase="/cab/AxNAROKPPD(3.3.2.3).cab#Version=3,3,2,3" width= "1" height= "1">
</object>


<%
	if("OK".equals(next_location)){
%>
	<form name="next_frm" method="post" action="RegistOrganInfoInPut.jsp">
		<input type="hidden" name="symm_enckey" value="<%=in_symm_enckey%>">
		<input type="hidden" name="eventdate" value="<%=in_eventdate%>">
		<input type="hidden" name="username" value="<%=in_username%>">
	</form>

	<script type="text/javascript">
		document.next_frm.submit();
	</script>

<%
	}

%>

