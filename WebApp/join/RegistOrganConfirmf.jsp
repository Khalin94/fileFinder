<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ksign.jce.util.*"%>
<%@ page import="ksign.jce.sample.*"%>

<%

	String regsid1 = "";
	String regsid2 = "";
	String resid_no = "";
	String call = "";
	
	String next_location = "";

	String in_symm_enckey = "";
	String in_regsid1 = "";
	String in_regsid2 = "";

	String Cip = request.getHeader("Proxy-Client-IP");
	String[] Tip= new String[4];
	String buffer = new String("");	

	byte[] org_regsid1 = null;
	byte[] org_regsid2 = null;

	int Tip0 = Integer.parseInt(Tip[0] = Cip.substring(0, Cip.indexOf(".")));
	buffer = Cip.substring(Cip.indexOf(".") + 1);
	int Tip1 = Integer.parseInt(Tip[1] = buffer.substring(0, buffer.indexOf(".")));
	buffer = buffer.substring(buffer.indexOf(".") + 1);
	int Tip2 = Integer.parseInt(Tip[2] = buffer.substring(0, buffer.indexOf(".")));
	int Tip3 = Integer.parseInt(Tip[3] = buffer.substring(buffer.indexOf(".") + 1));

	in_symm_enckey = request.getParameter("symm_enckey");
	in_regsid1 = request.getParameter("regsid1");
	in_regsid2 = request.getParameter("regsid2");

	java.util.Hashtable objHshParam = new java.util.Hashtable();
	java.util.Hashtable objHshReqUserInfo = new java.util.Hashtable();


	//����Ű���� safeon ��ȣ ����
	besoft.safeon.assembly.SafeonCryptModule scm = new besoft.safeon.assembly.SafeonCryptModule(request);
	String safeon_regsid1 = "";
	String safeon_regsid2 = "";
	safeon_regsid1 = scm.decrypt( request.getParameter("_E2E_SAFEON_regsid1") );
	safeon_regsid2 = scm.decrypt( request.getParameter("_E2E_SAFEON_regsid2") );
	
	
	//����Ű���� �Է��� ���
	if( safeon_regsid1.indexOf("DecryptError") == -1 && safeon_regsid2.indexOf("DecryptError") == -1 ){

		resid_no = safeon_regsid1 + safeon_regsid2;

	}else{ //����Ű���� �Է��� �ƴ� ���


		if (in_symm_enckey != null)
		{

			///////////////////////////////////////////////////// START
			System.out.println("Proxy-Client-IP" + Cip + "<BR>");
			System.out.println("<b>��ȣȭ��</b><br><b>Ű ��  :</b><br>&nbsp;" + in_symm_enckey + "<BR>");
			System.out.println("<b>in_regsid1 :</b><br>&nbsp;" + in_regsid1 + "<BR>");
			System.out.println("<b>in_regsid2 :</b><br>&nbsp;" + in_regsid2 + "<BR>");
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
				//byte[] org_regsid1 = symmdecrypt.SymmDecrypt(in_regsid1, key, "SEED");//����Ű�� ���� ��ȣȭ
				org_regsid1 = symmdecrypt.SymmDecrypt(in_regsid1, key, "SEED");//����Ű�� ���� ��ȣȭ
				//byte[] org_regsid2 = symmdecrypt.SymmDecrypt(in_regsid2, key, "SEED");
				org_regsid2 = symmdecrypt.SymmDecrypt(in_regsid2, key, "SEED");

				System.out.println("<b>������</b><br><b>Ű�� :</b><br>&nbsp;" + key + "<BR>");
				System.out.println("<b>in_regsid1 : </b><br>&nbsp;" + new String(org_regsid1) + "<br>");
				System.out.println("<b>in_regsid2 : </b><br>&nbsp;"	+ new String(org_regsid2) + "<br>");

			} catch (Exception e) {
				e.printStackTrace();
				System.out.println(e.toString());
				System.out.println("error1 :  " + e.toString());
				System.out.println("error2 : " + JCEUtil.getErrormsg());
				System.out.println("error3 : " + JCEUtil.getErrorcode());
			}
			///////////////////////////////////////////////////// END

			resid_no = (new String(org_regsid1)) + (new String(org_regsid2));


			//System.out.println( request.getParameter("_E2E_SAFEON_regsid1") );
			//System.out.println( request.getParameter("_E2E_SAFEON_regsid2") );
			//System.out.println( "safeon1 : " + regsid1 ); 
			//System.out.println( ",safeon2 : " + regsid2 ); 
			//����Ű���� safeon ��ȣ ��   

			System.out.println("resid_no :: "  + resid_no);
			boolean temp = this.isJumin(resid_no);
			if(!temp){
				out.println("<script language='javascript'>");
				out.println("alert('�߸��� �ֹι�ȣ �����Դϴ�.')");
				out.println(" window.location = '/index.html';");
				out.println("</script>");				
				return;
			}
			
		}

	}
	
	try{

		if(resid_no != null && !resid_no.equals("")){
			nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();
			objHshParam.put("CERT_DN","");
			objHshParam.put("JUMIN_NO",resid_no);

			objHshReqUserInfo = objJoinMemberDelegate.getUserInfo(objHshParam);			
			
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

<script type="text/javascript" src="/js2/jquery-1.4.2.min.js"></script>

<script type='text/javascript' src='/javascript/CKKeyPro_nosign.js'></script>


<script type="text/javascript">
	function funView(){
		var form = document.NAPS;	
		if(form.regsid1.value == ""){
			alert('�ֹι�ȣ�� �Է��� �ֽʽÿ�');
			form.regsid1.focus();
			return;
		}else if(form.regsid2.value == ""){
			alert('�ֹι�ȣ�� �Է��� �ֽʽÿ�');
			form.regsid2.focus();
			return;
		}else{
			form.action = "RegistOrganConfirmf.jsp";
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
                            <td>&bull;&nbsp;<strong>�ֹε�Ϲ�ȣ</strong></td>
                            <td><input type="password" name="regsid1" enc="on" size="15" value="<%=regsid1%>" onKeyUp="return autoTab(this, 6, event);" maxlength="6"> - <input type="password" name="regsid2" enc="on" size="20" value="<%=regsid2%>" maxlength="7" onKeyDown="javascript:funEnterCheck();">

											<!-- UsafeOn �����ư ��ġ ���� �±� --><span id="usafeon_regsid1|regsid2"  style="position:relative; padding-top:5px;" ></span>  </td>
							<td></td>
                        </tr>
                    </table>
                </div>
            </div>
            <div id="btn_all" class="t_right"> <span class="list_bt"><a href="javascript:funView();">Ȯ ��</a></span> <span class="list_bt"><a href="#" onclick="window.location='/index.html'">�� ��</a></span> </div>

            <!-- /����Ʈ ��ư--> 
            <span class="warning"> �ֹε�Ϲ�ȣ �Է½� Ű���� ���Ƚý����� �۵��Ǹ� [�����Է�]��ư�� ������ ����Ű���带 �̿��� �߰� ȭ�� �����Է��� �����մϴ�. ���� �Է±Ⱑ ȭ�鿡 �ߴ� ��� ������ŷ����, ȭ���������� ���� �� Ű�����Է����� ���⿡ ���� �߰�ȭ���Էº����� �����մϴ�.</span> </div>
    </div>
    <div id="log_footer"> <span class="copy" ><img src="/images2/login/copyright.gif" width="448" height="26" /></span></div>
</div>
 
<!-- besoft uSafeOn (����Ű���� ���) 2011-11-15 -->
<script type="text/javascript" src="/besoft/safeon/safeon.js" charset="utf-8"></script>
<!--<script type='text/javascript' src='/javascript/safeon20111228.js'></script>-->
<script language="javascript" src="/axkcase.js"></script>

<script type="text/javascript">
	safeonAddNumberField("NAPS", "regsid1|regsid2"); // �����е� ȣ�� (���̸�, �����ʵ����)
</script>  
<!-- //besoft uSafeOn (����Ű���� ���) 2011-11-15 -->

</form>

</body>
</html>

<%!
	public static boolean isJumin( String jumin ) { 
    	 boolean isKorean = true; 
    	 int check = 0;
    	 
    	 if( jumin == null || jumin.length() != 13 ) return false; 
    	 if( Character.getNumericValue( jumin.charAt( 6 ) ) > 4 && Character.getNumericValue( jumin.charAt( 6 ) ) < 9 ) { 
    	  isKorean = false; 
    	 } 

    	 for( int i = 0 ; i < 12 ; i++ ) { 
    	  if( isKorean ) check += ( ( i % 8 + 2 ) * Character.getNumericValue( jumin.charAt( i ) ) ); 
    	   else check += ( ( 9 - i % 8 ) * Character.getNumericValue( jumin.charAt( i ) ) ); 
    	 } 

    	 if( isKorean ) { 
    	  check = 11 - ( check % 11 ); 
    	  check %= 10; 
    	 }else { 
    	  int remainder = check % 11; 
    	  if ( remainder == 0 ) check = 1; 
    	  else if ( remainder==10 ) check = 0; 
    	  else check = remainder; 

    	  int check2 = check + 2; 
    	  if ( check2 > 9 ) check = check2 - 10; 
    	  else check = check2; 
    	 } 

    	 if( check == Character.getNumericValue( jumin.charAt( 12 ) ) ) return true; 
    	 else return false; 
    }
%>


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
			
				if(form.elements[i].name == "regsid1"){
					retValue_1 = document.CKKeyPro.GetEncData("",form.name, form.elements[i].name);			
					form.regsid1.value = retValue_1;
					
				}
				if(form.elements[i].name == "regsid2"){
					
					retValue_2 = document.CKKeyPro.GetEncData("",form.name, form.elements[i].name);
					form.regsid2.value = retValue_2;
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
		<input type="hidden" name="regsid1" value="<%=in_regsid1%>">
		<input type="hidden" name="regsid2" value="<%=in_regsid2%>">
		<!--����Ű����--> 
		<input type="hidden" name="_E2E_SAFEON_regsid1" value="<%= request.getParameter("_E2E_SAFEON_regsid1")%>">
		<input type="hidden" name="_E2E_SAFEON_regsid2" value="<%= request.getParameter("_E2E_SAFEON_regsid2")%>">
	</form> 

	<script type="text/javascript">
		document.next_frm.submit();
	</script>


<%
	}

%>