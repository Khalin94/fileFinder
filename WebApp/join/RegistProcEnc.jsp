<%@ page contentType="text/html;charset=euc-kr" %>

<%@ page import="nads.dsdm.app.activity.userinfo.KISA_SHA256" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.log.Log" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>

<head>

<title>�����ڷ���������ý���</title>

<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />

<meta http-equiv="Page-Enter" content="blendTrans(Duration=.01)" />

<meta http-equiv="Page-Exit" content="blendTrans(Duration=.01)" />

<script language="javascript" src="/axkcase.js"></script>
<script type="text/javascript" src="/js2/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/js2/jquery.selectbox-0.6.1.js"></script>
<script type="text/javascript" src="/js2/common.js"></script>
<script type='text/javascript' src='/javascript/CKKeyPro_nosign.js'></script>
<script src="/js/common.js" ></script>
<script src="/js/validate.js" ></script>
<script src="/js/validate2.js" ></script>

<title> Ȯ��</title>

<%

  String jomin_no  = request.getParameter("jomin_no");  
  
  Hashtable objResult = null;
  String emp_no = "";

  KISA_SHA256 kisa = new KISA_SHA256();
  byte[] plainText = jomin_no.getBytes("UTF-8");
  String jomin_no_enc = kisa.Sha256Encrypt(plainText);
  System.out.println("kangthis logs emp_no => " + jomin_no_enc);
  
  try {	
		//�ֹι�ȣ�� ���� ���� thssct19_enc ���̺��� emp_no����
		nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();
		objResult = objJoinMemberDelegate.getUserIdEmpNo(jomin_no_enc); 
		
		emp_no = (String)objResult.get("EMP_NO");		
                if(emp_no.equals("HU8212")) {
			emp_no = "";
		}
		System.out.println("kangthis logs EMP_NO ���ϰ� => " + emp_no);		
				
	}catch(Exception objExcept)	{
		Log.debug.println(objExcept.toString());
	}		
%>

<head>

</head>

<script>

function calls(){

	  var remote_form = parent.document.forms["formEmpNo"];
	  remote_form.emp_no.value = '<%=emp_no%>';

}

</script>

<script>


</script>

<body onload = 'javascript:calls()'>

</body>

</html>
