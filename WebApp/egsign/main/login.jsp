<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="jxl.write.* " %>
<!-- @@@ %@ page import="ksign.jce.util.Base64" %-->
<%@ page import="java.security.SecureRandom" %>
<%@ include file="../../raonnx/jsp/raonnx.jsp" %>

<head>
<title>�����ڷ���������ý���</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Page-Enter" content="blendTrans(Duration=.01)" />
<meta http-equiv="Page-Exit" content="blendTrans(Duration=.01)" />
<script type="text/javascript" src="/js2/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/js2/jquery.selectbox-0.6.1.js"></script>
<script type="text/javascript" src="/js2/common.js"></script>
<!-- <script type='text/javascript' src='/besoft/safeon/safeon.js' charset="utf-8" ></script> -->

<!-- @@@ script type='text/javascript' src='/javascript/CKKeyPro_nosign.js'></script-->
<!-- @@@ script language="javascript" src="/axkcase.js"></script -->

<link type="text/css" href="/css2/style.css" rel="stylesheet">

<%
/* @@@
  SecureRandom sr = new SecureRandom();
  sr.nextBoolean();
  byte[] bChallenge = new byte[30];
  sr.nextBytes(bChallenge);
  String sChallenge = Base64.encode2(bChallenge);  
  session.setAttribute("challenge", sChallenge);
 */
%>

<script language='javascript'>

/*--------------------------------------------
* Button Image Roll Over
--------------------------------------------*/
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function MM_openBrWindow2(theURL,winName,features)
{
	var winl = (screen.width - 600) / 2;
	var wint = (screen.height - 520) / 2;
	var winProp='width=600,height=520,scrollbars=yes, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no,top=' + wint + ',left=' + winl;
	window.open(theURL, winName, winProp);
}

function MM_openBrWindow3(theURL,winName,features)
{
	var winl = (screen.width - 1000) / 2;
	var wint = (screen.height - 920) / 2;
	var winProp='width=1000,height=920,scrollbars=yes, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no,top=' + wint + ',left=' + winl;
	window.open(theURL, winName, winProp);
}

function MM_openBrWindow(theURL,winName,features)
{

window.open(theURL,winName,features);
}

/*
function CheckAX()
{
	var Installed = false;
	// AxKSignCASE ������Ʈ �϶�
	var KSIGNActiveXProgID = "AxNAROKPPD.AxNAROKPPD.1"

	try
	{
		var xObj = new ActiveXObject(KSIGNActiveXProgID);

		if(xObj){
			Installed = true;
		}
		else
		{
			Installed = false;
		}
	}
	catch(ex)
	{
		Installed = false;
	}

	return Installed;
}
*/

function TryLogin(result){

	/* @@@
	var dn;
	var signeddata;	
	if(!CheckAX()) {
		alert("Ŭ���̾�Ʈ ���α׷��� ��ġ���� �ʾ� ������ �� �����ϴ�.");
		return;
	}

	dn = document.AxKCASE.SelectCert();
	if ((dn == null) || (dn == ""))
	{
		if(document.AxKCASE.GetErrorCode() != -1)
			alert(document.AxKCASE.GetErrorContent());
		return;
	}

	signeddata = document.AxKCASE.SignedData(dn, "", dn + "$" + document.loginform_cert.sChallenge.value);

	if( signeddata == null || signeddata == "" )
	{
		errmsg = document.AxKCASE.GetErrorContent();
		errcode = document.AxKCASE.GetErrorCode();
		alert( "������ �α��� ���� :"+errmsg );
		return;
	}
	*/	
	console.log(result);
	if(result.status==1){			
		//document.getElementById("ksbizSig").value = result.data;
	}else if(result.status==0){
		alert("������ ������ ����Ͽ����ϴ�.");
		return;
	}else if(result.status == -10301){
		//�����ü ��ġ�� ���� ���ڼ���â�� ������ ���
	}else if(result.status!=0){
		alert("���ڼ��� ����:" + result.message + "[" + result.status + "]");
		return;
	}

	document.loginform_cert.signed_data.value = result.data;
	document.loginform_cert.action = "./pkicert.jsp";
	//document.loginform_cert.action = "./test02.jsp";
	document.loginform_cert.submit();
}

/*--------------------------------------------
* �̿�ȳ�
--------------------------------------------*/
function MM_openBrWindow(theURL,winName,features){
	window.open(theURL,winName,features);
}


/*--------------------------------------------
* �˾�
--------------------------------------------*/
function setCookie( name, value, expiredays ){
        var today = new Date();
        today.setDate( today.getDate() + expiredays );
        document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + today.toGMTString() + ";";
}


// �����ڷ���������ý��� �������� POP��ũ
function popQnaViewCont(id,hid,num) {
    var objForm		= document.frmNAFSQna;
    var newWidth	= 600;
    var newHeight	= 520;
    var newLeft		= (screen.availWidth - newWidth)/2;
    var newTop		= (screen.availHeight - newHeight)/2;

    var pwin		= window.open('', 'popup_noti', 'left='+newLeft+',top='+newTop+',width='+newWidth+',height='+newHeight+',scrollbars=yes, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');

	objForm.qust_bltn_id.value = id;
	objForm.hupper_bltn_id.value = hid;
	objForm.num.value = num;

	objForm.target = "popup_noti";
	objForm.submit();
}	// end function :: popQnaViewCont


function getCookie(name) { 
	var Found = false ;
	var start, end ;
	var i = 0 ;

	// cookie ���ڿ� ��ü�� �˻� 
	while(i <= document.cookie.length) { 
	  start = i ;
		end = start + name.length ;
        	
	// name�� ������ ���ڰ� �ִٸ� 
		if(document.cookie.substring(start, end) == name) 
		{
		 	Found = true ;
			break ;
		} 

		i++ ;
	} 

	// name ���ڿ��� cookie���� ã�Ҵٸ� 
	if(Found == true) { 

		start = end + 1 ;
		end = document.cookie.indexOf(";", start) ;
        	
		// ������ �κ��̶� �� ���� �ǹ�(���������� ";"�� ����) 
		if(end < start) 
			end = document.cookie.length ;
        	
		// name�� �ش��ϴ� value���� �����Ͽ� �����Ѵ�. 
		return document.cookie.substring(start, end) ;
	} 

	// ã�� ���ߴٸ� 
	return "" ;
} ;

function PageForwarding(sDay, eDay) { 		
 	var eventCookie=getCookie("naps_assembly_go_kr");
	var sDay = "01/24/2018 10:00:00";
	var eDay = "01/27/2018 13:00:00";
	var today = new Date();
 	var startday = new Date(sDay);
 	var endday = new Date(eDay);

	if( today < endday && today >= startday) {
 		if (eventCookie != "done") {
 			window.open('notice_pop.jsp','_openPopup','width=520,height=295,top=50,left=150'); 
 		} 		
 	}
} ;

</script>
</head>

<body onload="PageForwarding();">
<div id="log_wrap">
    <div class="login">
        <h1><img src="/images2/login/logo.gif" width="316" height="31" />-----���� �׽�Ʈ-----</h1>
        <div class="imgArea">
            <!-- �˾��� -->
           <!-- <dl>
                <dt >�ý��� ���� ���Դϴ�.</dt>
                <dd><strong>����</strong><br />
                    �䱸�� �ۼ� �ý��� ���� ���Դϴ� �ż��� ��ġ �ϵ��� �ϰڽ��ϴ�.</dd>
            </dl> -->
            <!-- / �˾��� -->

            <!-- �α��� ������ ��߱� ��ư -->
            <ul>
                <li><a href="javascript:KeySharpBiz.login('', TryLogin);"><img src="/images2/login/bt_login.gif" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" /></a></li>
                <!--li><a href="https://naps.assembly.go.kr:444/join/RegistUserConfirmRe.jsp"><img src="/images2/login/bt_apply.gif" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" /></a></li-->
				<li><a href="http://172.16.47.178/join/RegistUserConfirmRe.jsp"><img src="/images2/login/bt_apply.gif" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" /></a></li>
            </ul>

            <!-- /�α��� ������ ��߱� ��ư -->

        </div>
        <div class="log_con">


         <!-- ������ ���� -->
            <ul>
                <h2><img src="/images2/login/movie_01.gif" width="133" height="37"  /></h2>
                <li><a href="javascript:MM_openBrWindow2('http://naps.assembly.go.kr/guide/GuideBoardContent.jsp?strCurrentPage=1&bbrdid=0000000016&dataid=0000001903','','width=600,height=520')"><img src="/images2/login/movie_02.gif" width="133" height="28" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" /></a> </li>
                <li><a href="javascript:MM_openBrWindow2('http://naps.assembly.go.kr/guide/GuideBoardContent.jsp?strCurrentPage=1&bbrdid=0000000016&dataid=0000001901','','width=600,height=520')""><img src="/images2/login/movie_03.gif" width="133" height="26"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a> </li>
                <li><a href="javascript:MM_openBrWindow2('http://naps.assembly.go.kr/guide/GuideBoardContent.jsp?strCurrentPage=1&bbrdid=0000000016&dataid=0000001902','','width=600,height=520')"><img src="/images2/login/movie_04.gif" width="133" height="27"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a> </li>	
			
            </ul>
       <!-- /�������� -->


       <!-- �߰���ư 3��-->            
			<!--<div class="apply_area"><a href="https://naps.assembly.go.kr:444/join/RegistOrganSearch.jsp"><img src="/images2/login/apply_bt_01.gif" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" /></a><a href="https://naps.assembly.go.kr:444/join/RegistUserConfirmPre.jsp"><img src="/images2/login/apply_bt_02.gif" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" /></a><a href="https://naps.assembly.go.kr:444/join/RegistUserTerms.jsp"><img src="/images2/login/apply_bt_03.gif" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"  /></a>
            </div>-->

			<div class="apply_area"><a href="http://172.16.47.178/join/RegistOrganSearch.jsp"><img src="/images2/login/apply_bt_01.gif" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" /></a><a href="http://172.16.47.178/join/RegistUserConfirmPre.jsp"><img src="/images2/login/apply_bt_02.gif" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" /></a><a href="http://172.16.47.178/join/RegistUserTerms.jsp"><img src="/images2/login/apply_bt_03.gif" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"  /></a>
            </div>
			
         <!-- /�߰���ư 3��-->



          <!-- �̿�ȳ� ���ǰԽ���-->
            <ul class="log_info">
                <li><a href="javascript:MM_openBrWindow('http://naps.assembly.go.kr/guide/admin_index.html','','width=725,height=672')">
				<a href="javascript:MM_openBrWindow('http://naps.assembly.go.kr/guide/admin_index.html','','width=725,height=672')"><img src="/images2/login/info_bt01.gif" width="86" height="14" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a><br />
                    <img src="/images2/login/info_t.gif" width="121" height="35" /></li>
                <li class="mt10"><a href="javascript:MM_openBrWindow('http://naps.assembly.go.kr/guide/qboard_index.html','','width=725,height=672')"><img src="/images2/login/info_bt02.gif" width="86" height="14" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li>
				
            </ul>
          <!-- �̿�ȳ� ���ǰԽ���-->
			

        </div>
    </div>
    <div id="log_footer">
        <p><img src="/images2/login/massage.gif" width="498" height="46" /></p>
        <span class="copy"><a href="javascript:MM_openBrWindow3('http://naps.assembly.go.kr/persnalinfo.htm','','width=600,height=520')"><img src="/images2/login/movie_04_con4.gif"/></a><img src="/images2/login/copyright.gif" width="448" height="26" /></span></div>
</div>
</body>
<!-- �������� �˾� ��� �߰�-->
<iframe frameborder="0" width="0" height="0" marginwidth="0" scrolling="yes" src="http://naps.assembly.go.kr/common/PopUp.jsp?strTypeParam=001"></iframe>
<!-- certificate login form -->
<form method="post" action="" name="loginform_cert">
    <input type='hidden' name='signed_data' >
    <!-- @@@ input type="hidden" name="sChallenge" value="sChallenge" -->
</form>


</html>
