<%@ page contentType="text/html;charset=euc-kr" %>

<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.all.ReqInfoAllInOneDelegate" %>
<%

	String call = "";
	String Cip = request.getHeader("Proxy-Client-IP");
	String[] Tip= new String[4];
	String buffer = new String("");	

	int Tip0 = Integer.parseInt(Tip[0] = Cip.substring(0, Cip.indexOf(".")));
	buffer = Cip.substring(Cip.indexOf(".") + 1);
	int Tip1 = Integer.parseInt(Tip[1] = buffer.substring(0, buffer.indexOf(".")));
	buffer = buffer.substring(buffer.indexOf(".") + 1);
	int Tip2 = Integer.parseInt(Tip[2] = buffer.substring(0, buffer.indexOf(".")));
	int Tip3 = Integer.parseInt(Tip[3] = buffer.substring(buffer.indexOf(".") + 1));

	String in_username = request.getParameter("username");
	String in_eventdate = request.getParameter("eventdate");

	java.util.Hashtable objHshParam = new java.util.Hashtable();
	java.util.Hashtable objHshReqUserInfo = new java.util.Hashtable();

	ResultSetHelper objOrganRs = null;
	ReqInfoAllInOneDelegate objReqAllOne = new ReqInfoAllInOneDelegate();
		

	try{
	   		/********* ���������� **************/
	    	objOrganRs=new ResultSetHelper(objReqAllOne.getReqOrganChart());   /** �Ҽ� ����ȸ */
		
		
	} catch(AppException objAppEx) { 
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
<link type="text/css" href="/css2/style.css" rel="stylesheet">
<script src="/js/common.js"></script>
<script src="/js/validate.js" ></script>
<script src="/js/activity.js"></script>
<script src="/js/formchek.js"></script>
<script type="text/javascript" src="/zipinfo/js/jquery-1.8.3.min.js"></script>		

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
<script language="javascript">
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
	//openWindow('http://naps.assembly.go.kr/zipinfo/roadSearchAddress.html', 'search', '500', '573', 'N');
	return false;
}
  function _callbackZipCode(data) {
  
// 	  POST_CD JUSO1

	  $("#POST_CD").val(data.zipcode);
	  $("#JUSO1").val(data.addr);
	  
// 		alert(data.zipcode);
// 		alert(data.addr);
// 		alert(data.gldbMnoKey);
// 		alert(data.sido);
// 		alert(data.gugun);
// 		alert(data.rod_addr);
    }
    
function checkOrganName(){
				
	if(document.NAPS.ORGAN_NM.value == "" ) { 
		alert("������� �Է��Ͻñ� �ٶ��ϴ�.");
		document.NAPS.ORGAN_NM.focus();
		return;
	}
	window.open("/join/OrganNameCheck.jsp?strOrganName="+document.NAPS.ORGAN_NM.value, "OrganNameCheck", "top=300,left=500,width=200,height=50,toolbar=no,menubar=no,location=no,scrollbars=no,status=no,resizable=no");
}

function organProcess() {
		if(document.NAPS.ORGAN_NM.value == "") {
			alert("������� �Է��� �ֽʽÿ�");
			document.NAPS.ORGAN_NM.focus();
			return;
		}	
		
		if(document.NAPS.POST_CD.value == "") {
			alert("�����ȣ�� �Է��� �ֽʽÿ�");
			document.NAPS.POST_CD1.focus();
			return;
		}
		/* if(document.NAPS.POST_CD1.value == "") {
			alert("�����ȣ�� �Է��� �ֽʽÿ�");
			document.NAPS.POST_CD1.focus();
			return;
		}

		if(document.NAPS.POST_CD2.value == "") {
			alert("�����ȣ�� �Է��� �ֽʽÿ�");
			document.NAPS.POST_CD2.focus();
			return;
		}*/
 
		if(document.NAPS.JUSO1.value == "") {
			alert("�⺻�ּҸ� �Է��� �ֽʽÿ�");
			document.NAPS.JUSO1.focus();
			return;
		}

		if(document.NAPS.JUSO2.value == "") {
			alert("���ּҸ� �Է��� �ֽʽÿ�");
			document.NAPS.JUSO2.focus();
			return;
		}

		if(document.NAPS.GOV_GBN.value ==""){
			alert("���������� ������ �ֽʽÿ�.");
			document.NAPS.GOV_GBN.focus();
			return;
		}

		
		
		if(document.NAPS.TEL_NUM.value ==""){
			alert("�繫�ǹ�ȣ�� �Է��� �ֽʽÿ�.");
			document.NAPS.TEL_NUM.focus();
			return;
		}	
		if(document.NAPS.FAX_NUM.value ==""){
			alert("FAX��ȣ�� �Է��� �ֽʽÿ�.");
			document.NAPS.FAX_NUM.focus();
			return;
		}	

		if(!isAlphanumeric(document.NAPS.GOV_STD_CD.value,  true)) {
			alert("����ǥ���ڵ�� ���� �� ���ڸ� �Է��� �ֽʽÿ�");
			document.NAPS.GOV_STD_CD.focus();
			return;
		}		

		varOrganNo = document.NAPS.strOrganNo1.value + document.NAPS.strOrganNo2.value + document.NAPS.strOrganNo3.value ;
		if(varOrganNo.length > 0 ) {
			if(!isInteger(varOrganNo)) {
				alert("����ڵ�Ϲ�ȣ�� ���ڸ� �Է��� �ֽʽÿ�");
				document.NAPS.strOrganNo1.focus();
				return;
			}			
			
			if(document.NAPS.strOrganNo1.value.length < 3) {
				alert("����ڵ�Ϲ�ȣ1�� �ڸ����� 3�ڸ��Դϴ�.");
				document.NAPS.strOrganNo1.focus();
				return;
			}
			if(document.NAPS.strOrganNo2.value.length < 2) {
				alert("����ڵ�Ϲ�ȣ2�� �ڸ����� 2�ڸ��Դϴ�.");
				document.NAPS.strOrganNo2.focus();
				return;
			}
			if(document.NAPS.strOrganNo3.value.length < 5) {
				alert("����ڵ�Ϲ�ȣ3�� �ڸ����� 5�ڸ��Դϴ�.");
				document.NAPS.strOrganNo3.focus();
				return;
			}
		}



		if(document.NAPS.checkFlag.value == "false" ) { 
			alert("����� �ߺ�üũ�� �Ͻñ� �ٶ��ϴ�.");
			return;
		}
		if(document.NAPS.ORGAN_NM.value != document.NAPS.checkORGAN_NM.value ) { 
			alert("����� �ߺ�üũ�� �Ͻñ� �ٶ��ϴ�.");
			document.NAPS.checkFlag.value = "false"; 
			return;
		}


					
		document.NAPS.action = "RegistOrganInfoInPutProc.jsp";
		document.NAPS.submit();
	}

	function checkOrganName(){
								
		if(document.NAPS.ORGAN_NM.value == "" ) { 
			alert("������� �Է��Ͻñ� �ٶ��ϴ�.");
			document.NAPS.ORGAN_NM.focus();
			return;
		}
		window.open("/join/OrganNameCheck.jsp?strOrganName="+document.NAPS.ORGAN_NM.value, "OrganNameCheck", "top=300,left=500,width=200,height=50,toolbar=no,menubar=no,location=no,scrollbars=no,status=no,resizable=no");
   }

   function selectZipCd(varZipCd, varAddr1)
	{
		var frm = document.forms[0];
		frm.POST_CD.value = varZipCd;
		//frm.POST_CD2.value = varZipCd2;
		frm.JUSO1.value = varAddr1;
	}

</script>
</head>

<body>
<form name="NAPS" method="post">
<div id="log_wrap">
    <div class="login">
        <h1><img src="/images2/login/logo02.gif" width="194" height="46" /></h1>
        <div class="user_con"> <br />
            <br />
            <!-- list --> 
            <span class="list02_tl">������� ���</span> <span class="list_total">(*) ǥ�ô� �ʼ� �׸� �Դϴ�.</span>
            <table border="0" cellspacing="0" cellpadding="0" class="list03" >
                <tr>
                    <th colspan="2" align="middle" valign="top">�����<span class="warning">*</span></th>
                    <td height="25"><input name="ORGAN_NM" style="width:250px;" / b />
                        <span class="list_bts"><a href="#" onclick="checkOrganName()">�ߺ��˻�</a></span>
						<input type="hidden" name="checkFlag" value="false">
						<input type="hidden" name="checkORGAN_NM" value="">
					</td>
                </tr>
                <tr>
                    <th colspan="2" align="middle" valign="top">�Ҽ�����ȸ</th>
                    <td height="25">
					<select name="AllCmtOrganID">
					<option value="">����ȸ�� �����Ͽ� �ּ���</option>
						<%while(objOrganRs.next()){							
							if(!(objOrganRs.getObject("ORGAN_ID")).equals("GI00006426")){
						%>
						<option value="<%=objOrganRs.getObject("ORGAN_ID")%>">
						<%=objOrganRs.getObject("ORGAN_NM")%></option>
						<%}}%>
					</select>
					</td>
                </tr>				
                <tr>
                    <th rowspan="3" align="middle" >�� ��</th>
                    <th align="middle" class="fonts" >�����ȣ<span class="warning" align="middle">*</span></th>
                    <td height="25" colspan="4"><input maxlength="7" name="POST_CD"  id="POST_CD" style="width:60px"/>
                        <!-- &nbsp;<span class="list_bts"><a href="#" onclick="winopen('/common/SearchZipCodePop2.jsp','SearchZipCodePop','height=450,width=500,scrollbars=yes,resize=yes')">�����ȣ�˻�</a></span></td> -->
                        &nbsp;<span class="list_bts"><a href="#" onclick="wincall()">�����ȣ�˻�</a></span></td>
                </tr>
                <tr>
                    <th align="middle" class="fonts" >�⺻�ּ�<span class="warning">*</span></th>
                    <td height="25"><input maxlength="100" name="JUSO1" id="JUSO1"  style="width:350px;"/></td>
                </tr>
                <tr>
                    <th align="middle" class="fonts" >���ּ�<span class="warning">*</span></th>
                    <td height="25" colspan="2"><input maxlength="100" name="JUSO2" style="width:350px;" /></td>
                </tr>
                <tr>
                <tr>
                    <th rowspan="2" align="middle" >��ȭ��ȣ</th>
                    <th width="85" height="25" class="fonts" >�繫��<span class="warning">*</span></th>
                    <td height="25" colspan="2">
                        <input maxlength="15" name="TEL_NUM" style="width:150px"/>
                        </td>
                </tr>
                <input value="0081" maxlength="4" type="hidden" name="innerphone" />
                <tr>
                    <th height="25" class="fonts"  >FAX<span class="warning">*</span></th>
                    <td height="25" colspan="2">
                        <input maxlength="15" name="FAX_NUM" style="width:150px"/>
                      </td>
                </tr>
                <tr>
                    <th colspan="2" align="middle" valign="top">����ڵ�Ϲ�ȣ<span class="warning">*</span></th>
                    <td height="25">
					<input name="strOrganNo1"  style="WIDTH: 30px"  maxlength="3"> - 
					<input name="strOrganNo2"  style="WIDTH: 20px"  maxlength="2"> - 
					<input name="strOrganNo3"  style="WIDTH: 50px"  maxlength="5">
					
					</td>
                </tr>
                <tr>
                    <th colspan="2" align="middle" valign="top">Ȩ������ �ּ�</th>
                    <td height="25">http://
                        <input maxlength="30" name="HOME_URL"  style="width:250px;"/></td>
                </tr>
                <tr>
                    <th colspan="2" align="middle" valign="top">�����������<span class="warning">*</span></th>
                    <td height="25"><select name="GOV_GBN"  style="WIDTH: 123px">
                    <option vlalue=""><<��������>></option>
                    <option value="G">����</option>
                    <option value="N">������</option>
                  </select></td>
                </tr>
                <tr>
                    <th colspan="2" align="middle" valign="top">����ǥ���ڵ�</th>
                    <td height="25"><input maxlength="7" name="GOV_STD_CD"  style="width:250px;"/></td>
                </tr>
            </table>
            <!-- /list -->
            <div id="btn_all" class="t_right"> <span class="list_bt"><a href="javascript:organProcess();">�� û</a></span> <span class="list_bt"><a href="#" onclick="window.location='/index.html'">�� ��</a></span> </div>
            
            <!-- /����Ʈ ��ư--> 
            
        </div>
    </div>
    <div id="log_footer"> <span class="copy" ><img src="/images2/login/copyright.gif" width="448" height="26" /></span></div>
</div>
<input type="hidden" name="strReqSubmtCd" value="002">
<input type="hidden" name="STT_CD" value="003">
<input type="hidden" name="REMARK" value="">
<input type="hidden" name="DUTY_SIZE" value="0">
<input type="hidden" name="ORGAN_GBN" value="001">
<input type="hidden" name="ORGAN_KIND" value="006">
<input type="hidden" name="INOUT_GBN" value="X">
<input type="hidden" name="BUSEORANKING"  value="0">
<input type="hidden" name="eventdate" value="<%=in_eventdate%>">
<input type="hidden" name="username" value="<%=in_username%>">
</form>
</body>
</html>
