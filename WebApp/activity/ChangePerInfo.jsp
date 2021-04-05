<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.security.cert.*" %>
<%@ page import="java.security.spec.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javak.crypto.*" %>
<%@ page import="javak.crypto.spec.*" %>

<%@ page import="com.raonsecure.ksbiz.log.KSBizLogger"%>
<%@ page import="com.raonsecure.ksbiz.*" %>
<%@ page import="com.raonsecure.ksbiz.crypto.*" %>

<%
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Pragma","no-cache"); 
	response.setDateHeader("Expires",0);
%>

<%
	//	nafs_login.jsp에서 넘어온 pkcs#7 signeddata 값
	String signData = request.getParameter("signed_data");
	String dn = "";
	String issuer_dn = "";
	String url = "";
	String err_msg = "";
	String err_msg_1 = "";
	String err_msg_2 = "";
	Enumeration el = null;
		String strCn;
    
	System.out.println("TEST => SignedData Input : " + signData +"<BR>");
	System.out.println("DN DATA : " + session.getAttribute("dn") +"<BR>");
	
	//String tempdn = (String)session.getAttribute("dn");

	Certificate[] certs; // 인증서를 담음
	

	KSBiz_v2 ksobj = new KSBiz_v2();
	boolean isVerify = false;

	int errorCode=-1;
	String errorMsg = "";
	
        
	try
	{

		ksobj.libInit();
		System.out.println("lib init success");
		
		ksobj.verify(signData);
		errorCode = ksobj.getErrorCode();
		if(errorCode != 0)
		{
			errorMsg = ksobj.getErrorMsg();
		}
		else
		{
			dn = ksobj.getCertInfo(KSBizCertInfo.SUBJECTDN);
			issuer_dn = ksobj.getCertInfo(KSBizCertInfo.ISSUERDN);

			isVerify = true;

			if(session.getAttribute("CERT_DN") == null || session.getAttribute("CERT_DN") == "") {
				String tempdn = (String)session.getAttribute("dn");
				
				if(!tempdn.equals(dn)){
					out.println("<script language='JavaScript'>");
					out.println("alert('인증서정보가 일치하지 않습니다.')");
					out.println("self.location.replace('/login/LogOut.jsp');");
					out.println("</script>");
					return;				
				}
				
			} else {
				String tempdn = (String)session.getAttribute("CERT_DN");
				if(!tempdn.equals(dn)){
					out.println("<script language='JavaScript'>");
					out.println("alert('인증서정보가 일치하지 않습니다.')");
					out.println("self.location.replace('/login/LogOut.jsp');");
					out.println("</script>");
					return;
				}
			}
		}
		
	}
	catch(Exception e){
    	e.printStackTrace();	  	
	  	System.out.println(e.toString()+"<BR>");	
		out.println("<script language='JavaScript'>");
		out.println("alert('인증서 확인중 문제가 발생하였습니다. 관리자에게 문의하세요')");
		out.println("self.location.replace('/login/LogOut.jsp');");
		out.println("</script>");
		return;
	}


%>

<jsp:include page="/inc/header.jsp" flush="true"/>
</head>
<script src="/js/forum.js"></script>
<script src="/js/common.js"></script>
<script src="/js/validate.js" ></script>
<script src="/js/activity.js" ></script>
<script type="text/javascript" src="/zipinfo/js/jquery-1.8.3.min.js"></script>
<script language="javascript">
	var winBG;

	function fun_view() {
		var img;

		if(img == "")
		{
			alert("선택된 사진이 없습니다.");
			return;
		}

		if(img != ""){
			var vafile = document.form_main.photo_path.value.substr(document.form_main.photo_path.value.length - 4, document.form_main.photo_path.value.length);
			if((vafile.toLowerCase() != ".gif") && (vafile.toLowerCase() != ".jpg") &&
			   (vafile.toLowerCase() != ".bmp") && (vafile.toLowerCase() != ".jpeg")){
				alert("사진파일은 확장명이 .gif, .jpg .jpeg .bmp 만 등록할 수 있습니다." + vafile);
				return;
			}
		}

		img=document.form_main.photo_path.value;
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

	function fun_update(){
		var varCnt;

		//Email는 반드시 있어야 한다.
		if(document.form_main.email.value == ""){
			alert("Email는 반드시 있어야 합니다.");
			document.form_main.email.focus();
			return;
		}

		//이동통신번호는 반드시 있어야 한다.
		if((document.form_main.cphone1.value == "") || (document.form_main.cphone2.value == "")
			|| (document.form_main.cphone3.value == "")){
			alert("이동통신번호는 반드시 있어야 합니다.");
			document.form_main.cphone2.focus();
			return;
		}

		//사무실전화번호는 반드시 있어야 한다.
		if((document.form_main.office_tel1.value == "") || (document.form_main.office_tel2.value == "")
			|| (document.form_main.office_tel3.value == "")){
			alert("사무실전화번호는 반드시 있어야 합니다.");
			document.form_main.office_tel1.focus();
			return;
		}

		//FAX번호는 반드시 있어야 한다.
		if((document.form_main.fax_no1.value == "") || (document.form_main.fax_no2.value == "")
			|| (document.form_main.fax_no3.value == "")){
			alert("FAX번호는 반드시 있어야 합니다.");
			document.form_main.fax_no1.focus();
			return;
		}

		//우편번호는 반드시 있어야 한다.
		/* if((document.form_main.post_cd1.value == "") || (document.form_main.post_cd2.value == "")){
			alert("우편번호는 반드시 있어야 합니다.");
			document.form_main.post_cd1.focus();
			return;
		} */
		if((document.form_main.post_cd.value == "")){
			alert("우편번호는 반드시 있어야 합니다.");
			document.form_main.post_cd.focus();
			return;
		}

		//기본주소는 반드시 있어야 한다.
		if(document.form_main.juso1.value == ""){
			alert("기본주소는 반드시 있어야 합니다.");
			document.form_main.juso1.focus();
			return;
		}

		//상세주소는 반드시 있어야 한다.
		if(document.form_main.juso2.value == ""){
			alert("상세주소는 반드시 있어야 합니다.");
			document.form_main.juso2.focus();
			return;
		}

		//담당업무는 반드시 선택해야 함(담당업무는 외부사용자만 있음)
		var varCheck = 0;
		var varCnt = 0;
		for(var i=0; i < document.form_main.elements.length; i++){
			if(document.form_main.elements[i].name.substring(0,4)=='mchr'){
				varCnt = parseInt(varCnt + 1);
				if(document.form_main.elements[i].checked == true){
					varCheck = 1;
					break;
				}
			}
			if(document.form_main.elements[i].name.substring(0,4)=='schr'){
				varCnt = parseInt(varCnt + 1);
				if(document.form_main.elements[i].checked == true){
					varCheck = 1;
					break;
				}
			}
		}

		if((varCnt > 0) && (varCheck == 0)){
			alert("담당업무는 반드시 있어야 합니다.");
			return;
		}

		if(document.form_main.photo_path.value != ""){
			var vafile = document.form_main.photo_path.value.substr(document.form_main.photo_path.value.length - 4, document.form_main.photo_path.value.length);
			if((vafile.toLowerCase() != ".gif") && (vafile.toLowerCase() != ".jpg") &&
			   (vafile.toLowerCase() != ".bmp") && (vafile.toLowerCase() != ".jpeg")){
				alert("사진파일은 확장명이 .gif, .jpg .jpeg .bmp 만 등록할 수 있습니다." );
				return;
			}
		}

		 if(checkStrLen(form_main.juso1, 100, "기본주소") == false){
            form_main.juso1.focus();
            return;
        }

        if(checkStrLen(form_main.juso2, 100, "상세주소") == false){
            form_main.juso2.focus();
            return;
        }

        if(checkStrLen(form_main.dept_nm, 40, "부서") == false){
            form_main.dept_nm.focus();
            return;
        }

        if(checkStrLen(form_main.email, 30, "E-Mail") == false){
            form_main.email.focus();
            return;
        }

        if(checkStrLen(form_main.cg_duty, 100, "담당업무") == false){
            form_main.cg_duty.focus();
            return;
        }

        if(checkStrLen(form_main.remark, 500, "비고") == false){
            form_main.remark.focus();
            return;
        }

        if (OnValidationSubmit() == false){
        	return;
        }
		document.form_main.submit();
	}

	function fun_break(){

		var strsystemgbn = document.form_main.system_use_gbn.value;
		var url = "InputBreakReasonPop.jsp?system_use_gbn="+strsystemgbn;
		window.open(url,'New','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=no,width=400,height=260,left=0,top=0');
	}

	function selectZipCd(varZipCd, varAddr1)
	{
		var frm = document.form_main;
		frm.post_cd.value = varZipCd;
		//frm.post_cd2.value = varZipCd2;
		frm.juso1.value = varAddr1;
	}

	function fun_cancel(){
		//location.href="/activity/ChangePerInfo.jsp";
		//운영에서도 오류발생 2015.05.08 ksw
		location.href="/activity/MyReqSubmitSearch.jsp";
	}

	function fun_successor(){
		var url = "CreatePerInfoPop.jsp?gubn=3";
		window.open(url,'New','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=705,height=525,left=0,top=0');
	}

	function fun_check(varObj){
		var varCheck ='';
		if(varObj.checked == true){
			varCheck = 'document.form_main.s' + varObj.name.substring(1, varObj.name.length)
			                      + '.disabled = true';
		}else{
			varCheck = 'document.form_main.s' + varObj.name.substring(1, varObj.name.length)
			                      + '.disabled = false';

		}
		eval(varCheck);
	}

	function fun_checkm(varObj){
		var varCheck ='';
		if(varObj.checked == true){
			varCheck = 'document.form_main.m' + varObj.name.substring(1, varObj.name.length)
			                      + '.disabled = true';
		}else{
			varCheck = 'document.form_main.m' + varObj.name.substring(1, varObj.name.length)
			                      + '.disabled = false';

		}
		eval(varCheck);
	}

	function fun_checketc(varGubn){
		varEtc = '';
		if (form_main.mchr999 == null){
			alert("담당업무에서 기타코드가 변동되었습니다.(관리자에게 확인요망)");
			return;
		}
		if (form_main.schr999 == null){
			alert("담당업무에서 기타코드가 변동되었습니다.(관리자에게 확인요망)");
			return;
		}

		if(varGubn == 'm'){
			if(form_main.mchr999.checked = true){
				varEtc = "document.form_main.mcharge.type = " + "'hidden'";
			}else{
				varEtc = "document.form_main.mcharge.type = " + "'text'";
			}
		}else{
			if(form_main.schr999.checked = true){
				varEtc = "document.form_main.scharge.type = " + "'hidden'";
			}else{
				varEtc = "document.form_main.scharge.type = " + "'text'";
			}

		}
		eval(varEtc);
	}

	function fun_make(varGubn, varValue) {
		var txtbox=" ";

		if(varGubn == 'm'){
			if(form_main.mchr999.checked == true){
				txtbox=txtbox+"<br><input type=text name='mcomment' class='textfield' width='15' maxlength='400' value='" + varValue +"'></br>";
				layer1.innerHTML = txtbox;
				document.form_main.mcomment.focus();
			}else{
				txtbox=txtbox+"";
				layer1.innerHTML = txtbox;
			}
		}else{
			if(form_main.schr999.checked == true){
				txtbox=txtbox+"<br><input type=text name='scomment' class='textfield' width='15'  maxlength='400' value='" + varValue +"'></br>";
				layer2.innerHTML = txtbox;
				document.form_main.scomment.focus()
			}else{
				txtbox=txtbox+"";
				layer2.innerHTML = txtbox;
			}
		}
	}

	function init()
	{

		// 필수입력
		define('office_tel1', 'num', '사무실전화번호', 2,3);
		define('office_tel2', 'num', '사무실전화번호', 3,4);
		define('office_tel3', 'num', '사무실전화번호', 4,4);
		define('fax_no1', 'num', '팩스번호', 2,3);
		define('fax_no2', 'num', '팩스번호', 3,4);
		define('fax_no3', 'num', '팩스번호', 4,4);
		define('cphone2', 'num', '핸드폰', 3,4);
		define('cphone3', 'num', '핸드폰', 4,4);
		define('post_cd', 'num', '우편번호', 7,7);
		//define('post_cd1', 'num', '우편번호', 3,3);
		//define('post_cd2', 'num', '우편번호', 3,3);
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
		  $("#post_cd").val(data.zipcode);
		  $("#juso1").val(data.addr);
	}

</script>
<body>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu01.jsp" flush="true"/>
<%@ include file="/common/CheckSession.jsp" %>
<%@ include file="userinfo/SelectUserInfoProc.jsp" %>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu01.jsp" flush="true"/>
    </div>
    <div id="rightCon">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg_my.jpg) no-repeat left top;">
        <h3>개인정보변경 <!-- <span class="sub_stl" >- 상세보기</span> --></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > 나의페이지 > 개인정보변경</div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 각페이지 내용 -->

        <div class="myP">

          <!-- list -->
<form name="form_main" method="post" action="http://naps.assembly.go.kr/activity/userinfo/UpdateUserInfoProc.jsp" enctype="multipart/form-data">
<!-- <form name="form_main" method="post" action="http://10.201.13.21:9000/activity/userinfo/UpdateUserInfoProc.jsp" enctype="multipart/form-data"> -->
<input type="hidden" name="system_use_gbn" value="<%=strSystemGbn%>">
<input type="hidden" name="organ_id" value="<%=strOrgPosiOrganId%>">
          <table border="0" cellspacing="0" cellpadding="0" class="list03" >
            <tr>
              <th width="18%" rowspan="4" align="middle" valign="top">
			<%
				if(strPhotoPath.length()  < 1){
			%>
			  <img src="/images2/foundation/pic.gif" width="110" height="120" class="pic" />
			<%
				}else{
			%>
			<%
				nads.lib.reqsubmit.encode.Base64Code base = new nads.lib.reqsubmit.encode.Base64Code();
				nads.lib.reqsubmit.util.HashEncrypt base2 = new nads.lib.reqsubmit.util.HashEncrypt();
			%>
			<img src="mem_info_pic.jsp?mem_code=<%=base.encode(base2.encrypt(strPhotoPath))%>" width="110" height="120" class="pic">
			<%
				}
			%>
			  </th>
              <th width="85" align="middle">이름</th>
              <td ><%=strUserNm%></td>
            </tr>
            <tr>
            <% 
            	if (strSessInOutGbn.equals("X")) { //외부사용자는 생년월일을 내부사용자는 개인식별정보를 보여준다 2015.05.01(kangthis) 
            %>
              <th align="middle">생년월일</th>
              <td height="25"><%=strJuminNo%></td>
              <% 
              	} else {
              %>
              <th align="middle">개인식별번호</th>
              <td height="25"><%=strJuminNo%></td>
              <% 
              	}
              %>
            </tr>
            <!--<tr>
              <th align="middle">성별</th>
              <td height="25"><%=strGender%></td>
            </tr>-->
            <tr>
              <th align="middle">기관명</th>
			  <%
					String strRepFlagDisplay = "";
					if(strSessInOutGbn.equals("X")){ //외부사용자는 기관명을 내부사용자는 국회 하위의 상급기관(예>국회<-'국회사무처')을 보여준다.
						strRepFlagDisplay = ""; //외부사용자는 대표여부를 수정할 수 있게 한다.
			  %>
              <td height="25"><%=strOrganNm%></td>
				<%
					}else{
						strRepFlagDisplay = "disabled"; //내부사용자는 대표여부를 수정할 수 없다.
				%>
				 <td height="25"><%=strHighOrganNm%></td>
				<%
					}
				%>
            </tr>
            <tr>
              <th align="middle" valign="top">가입일자</th>
              <td height="25"><%=strInitDate%></td>
            </tr>
            <tr>
              <th colspan="2" align="middle" valign="top">부서명</th>
              <td height="25">
			<%
				if(strSessInOutGbn.equals("X")){ //외부사용자는 부서명(tbdm_user_info)를 내부사용자는 기관을 보여주며, 외부사용자만 수정할 수 있다.
			%>
			  <input value="<%=strDeptNm%>" name="dept_nm" style="width:250px;" / b>
			  <%
					}else{
				%>
				<input value="<%=strOrganNm%>" name="dept_nm" style="width:250px;" / b>
				<%
					}
				%>
			  </td>
            </tr>

			<tr>
              <th colspan="2" align="middle" valign="top">직위</th>
              <td height="25"><input value="<%=strposiNm%>" name="posi_nm" style="width:250px;" / b></td>
            </tr>
			<tr>
              <th colspan="2" align="middle" valign="top">직급</th>
              <td height="25"><input value="<%=strgrdNm%>" name="grd_nm" style="width:250px;" / b></td>
            </tr>

            <tr>
              <th colspan="2" align="middle" valign="top">e-mail<span class="warning">*</span></th>
              <td height="25"><input value="<%=strEmail%>" maxlength="30" name="email"  style="width:250px;"/></td>
            </tr>
            <tr>
              <th rowspan=<%if(strInoutGbn.equals("I")){%>"4"<%}else{%>"3"<%}%> align="middle" >전화번호</th>
              <th height="25" class="fonts" >사무실<span class="warning">*</span></th>
              <td height="25" colspan="2"><input value="<%=strOfficeTel1%>" maxlength="3" name="office_tel1" style="width:60px"/>
                -
                <input value="<%=strOfficeTel2%>" maxlength="4" name="office_tel2" style="width:60px"/>
                -
                <input value="<%=strOfficeTel3%>" maxlength="4" name="office_tel3" /></td>
            </tr>
			<%if(strInoutGbn.equals("I")){%>
			 <tr>
              <th align="middle" class="fonts">내선번호<span class="warning">*</span></th>

              <td height="25" colspan="2">02
                -
				788
                -
                <input value="<%=strInnerPhone%>" maxlength="4" name="innerphone" /></td>
            </tr>
			<%}else{%>
			<input value="<%=strInnerPhone%>" maxlength="4" type="hidden" name="innerphone" />
			<%}%>
            <tr>
              <th height="25" class="fonts"  >FAX<span class="warning">*</span></th>
              <td height="25" colspan="2"><input value="<%=strFaxNo1%>" maxlength="3" name="fax_no1"  style="width:60px"/>
                -
                <input value="<%=strFaxNo2%>" maxlength="4" name="fax_no2" style="width:60px"/>
                -
                <input value="<%=strFaxNo3%>" maxlength="4" name="fax_no3" /></td>
            </tr>
            <tr>
              <th height="25" class="fonts" >이동통신번호<span class="warning">*</span></th>
              <td height="25" colspan="2"><select name="cphone1">
                  <option <%=strCphone1_010%> value="010">010</option>
				  <option <%=strCphone1_011%> value="011">011</option>
				  <option <%=strCphone1_016%> value="016">016</option>
				  <option <%=strCphone1_017%> value="017">017</option>
				  <option <%=strCphone1_018%> value="018">018</option>
				  <option <%=strCphone1_019%> value="019">019</option>
                </select>
                -
                <input value="<%=strCphone2%>" maxlength="4" name="cphone2" />
                -
                <input value="<%=strCphone3%>" maxlength="4" name="cphone3" /></td>
            </tr>
            <tr>
              <th rowspan="3" align="middle" >근무지</th>
              <th align="middle" class="fonts" >우편번호<span class="warning">*</span></th>
              <td height="25" colspan="4"><input value="<%=strPostCd%>" maxlength="7" name="post_cd" id="post_cd" style="width:60px"/>
                <!-- &nbsp;<span class="list_bts"><a href="#" onclick="winopen('/common/SearchZipCodePop2.jsp','SearchZipCodePop','height=450,width=520,scrollbars=yes,resize=yes')">우편번호검색</a></span></td> -->
                &nbsp;<span class="list_bts"><a href="#" onclick="wincall()">우편번호검색</a></span></td>
            </tr>
            <tr>
              <th align="middle" class="fonts" >기본주소<span class="warning">*</span></th>
              <td height="25"><input value="<%=strJuso1%>" maxlength="100" name="juso1" id="juso1" style="width:350px;"/></td>
            </tr>
            <tr>
              <th align="middle" class="fonts" >상세주소<span class="warning">*</span></th>
              <td height="25" colspan="2"><input value="<%=strJuso2%>" maxlength="100" name="juso2" style="width:350px;" /></td>
            </tr>
<%
	String strMsortCd = "";   //담당업무코드
	String strCdNm = "";       //코드명

	String strType = "";         //주:부업무 구분
	String strCharge = "";     //사용자 담당업무코드

	String strChecked = "";
	String strDisabled = "";
	String strFunction = "";
	String strChkName = "";
	String strSpace = "";
	String strMRemark = "";
	String strSRemark = "";
	String strTextType="hidden";

	if(strSessInOutGbn.equals("X")){ //담당업무는 외부사용자에게만 보여집니다.
%>
			<tr>
              <th rowspan="2" align="middle" >담당업무<span class="warning">*</span></th>
              <th align="middle" class="fonts" >주업무</th>
			  <td height="25" colspan="5">
<%
		Hashtable objChargeInfoHt = new Hashtable();
		Hashtable objUserChargeHt = new Hashtable();
		for(int i=0; i < objChargeInfoArry.size(); i++){
			objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
			strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
			strCdNm = (String)objChargeInfoHt.get("CD_NM");

			strChecked = "";
			strDisabled = "";
			for(int k=0; k < objUserChargeArry.size(); k++){
				objUserChargeHt = (Hashtable)objUserChargeArry.get(k);
				strType = (String)objUserChargeHt.get("CHARGE_TYPE");
				strCharge = (String)objUserChargeHt.get("CHARGE_CD");
				if(strType.equals("S") && !strCharge.equals("999")){  ////담당업무가 기타항목이 아닐 경우 적용
					if(strCharge.equals(strMsortCd)){
						strDisabled = "disabled";
						break;
					}
					continue;
				}
				if(strType.equals("M") && strCharge.equals(strMsortCd)){
					strChecked = "checked";
					if(strCharge.equals("999")){   //담당업무가 기타항목에 적용
						strMRemark = (String)objUserChargeHt.get("REMARK");
					}
					break;
				}
			}
			if(strMsortCd.equals("999")){   //담당업무가 기타항목에 적용
				strDisabled = "";
				strChkName = "mchr999";
				strSpace = "";
				strFunction = "fun_make('m', '" + strMRemark + "')";
			}else{
				strChkName = "mchr" + Integer.toString(i);
				strFunction = "fun_check(this)";
				strSpace = "&nbsp;&nbsp;";
			}
%>

			  <input name="<%=strChkName%>" class=" borderNo" type="checkbox" value="<%=strMsortCd%>"   <%=strChecked%>  <%=strDisabled%> onclick="<%=strFunction%>"><%=strCdNm%><%=strSpace%>
<%
		}//for(int k=0; k < objUserChargeArry.size(); k++){
%>

<span id="layer1"></span>
            </tr>
            <tr>
              <th align="middle" class="fonts" >부업무</th>
			  <td height="25">
<%
		strChecked = "";
		strDisabled = "";
		strFunction = "";
		strTextType="hidden";
		strChkName = "";
		strSpace = "";
		strSRemark = "";

		for(int i=0; i < objChargeInfoArry.size(); i++){
			objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
			strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
			strCdNm = (String)objChargeInfoHt.get("CD_NM");

			strChecked = "";
			strDisabled = "";
			for(int k=0; k < objUserChargeArry.size(); k++){
				objUserChargeHt = (Hashtable)objUserChargeArry.get(k);
				strType = (String)objUserChargeHt.get("CHARGE_TYPE");
				strCharge = (String)objUserChargeHt.get("CHARGE_CD");
				if(strType.equals("M")){
					if(strCharge.equals(strMsortCd) && !strCharge.equals("999")){ //담당업무가 기타항목이 아닐 경우 적용
						strDisabled = "disabled";
						break;
					}
					continue;
				}
				if(strType.equals("S") && strCharge.equals(strMsortCd)){
					strChecked = "checked";
					if(strCharge.equals("999")){   //담당업무가 기타항목에 적용
						strSRemark = (String)objUserChargeHt.get("REMARK");
					}
					break;
				}
			}
			if(strMsortCd.equals("999")){   //담당업무가 기타항목에 적용
				strDisabled = "";
				strSpace = "";
				strChkName = "schr999";
				strFunction = "fun_make('s', '" + strSRemark + "')";
			}else{
				strChkName = "schr" + Integer.toString(i);
				strFunction = "fun_checkm(this)";
				strSpace = "&nbsp;&nbsp;";
			}
%>

				<input name="<%=strChkName%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> onclick="<%=strFunction%>"><%=strCdNm%><%=strSpace%>
<%
		}//for(int i=0; i < objChargeInfoArry.size(); i++){
%>
<%
	}//if(strSessInOutGbn.equals("X")){ //담당업무는 외부사용자에게만 보여집니다.
%>

<span id="layer2"></span>
			 <br />
                </span></td>
            </tr>
            <tr>
              <th height="25" colspan="2" align="middle">대표자여부<span class="warning">*</span></th>
              <td height="25"><input value="Y" checked="checked" type="radio" name="rep_yn" class=" borderNo" <%=strRepFlagDisplay%> <%=strRepFlagY%>/>
                대표자
                <input value="N" type="radio" name="rep_yn"  class=" borderNo" <%=strRepFlagDisplay%> <%=strRepFlagN%>/>
                일반 <span class="warning">※ 대표자로 설정하는 경우 해당기관의 요구서 등록 시 문자 알림서비스 (국회기관 담당자 여부)</span></td>
            </tr>
            <tr>
              <th height="25" colspan="2">사진등록</th>
              <td onMouseOver="showtip(this,event,'사진크기:공무원증(가로 5cm * 세로 4cm )')" title="사진크기:공무원증(가로 5cm * 세로 4cm )" onMouseOut="hidetip()" height="25" colspan="2"><input type="file" name="photo_path" /></td>
            </tr>
            <tr>
              <th height="65" colspan="2">자기소개</th>
              <td height="65" colspan="2"><textarea wrap="hard" name="remark" style="width:400px; height:65px;"><%=strRemark%></textarea></td>
            </tr>
          </table>
          <!-- /list -->

          <!-- 리스트 버튼-->
          <div id="btn_all" >
<%
		if(strInoutGbn.equals("X") && strGovGbn.equals("N")){ //외부사용자이면서 비행정기관만 후임자지정을 할 수 있습니다.
%>
		   <!--<span class="right"> <span class="list_bt"><a href="javascript:fun_successor()">후임자등록</a></span></span>-->
<%
					}
%>
			<span class="right"> <span class="list_bt"><a href="javascript:fun_cancel()">취소</a></span></span>
			<span class="right"> <span class="list_bt"><a href="javascript:fun_break()">탈퇴신청</a></span></span>
			<span class="right"> <span class="list_bt"><a href="javascript:fun_update()">저장</a></span></span>
		 </div>
          <!-- /리스트 버튼-->

          <!-- /각페이지 내용 -->
        </div>
        <!-- /contents -->

      </div>
    </div>
</form>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
<%
	if(strSessInOutGbn.equals("X")){ //담당업무는 외부사용자에게만 보여집니다.
%>
<script language="javascript">
		fun_make('m', '<%=strMRemark%>');
		fun_make('s', '<%=strSRemark%>');
</script>
<%
	}//if(strSessInOutGbn.equals("X")){ //담당업무는 외부사용자에게만 보여집니다.
%>
</html>
