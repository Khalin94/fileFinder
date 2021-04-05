<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/System.css" rel="stylesheet" type="text/css">
</head>

<script src="/js/forum.js"></script>
<script src="/js/common.js"></script>
<script src="/js/validate.js" ></script>
<script src="/js/activity.js" ></script>
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

	function fun_create(){
		var varCnt;
		//사용자이름는 반드시 있어야 한다.
		if(document.form_main.user_nm.value == ""){
			alert("사용자이름는 반드시 있어야 합니다.");
			document.form_main.user_nm.focus();
			return;
		}

		if((document.form_main.jumin_no1.value == "") || (document.form_main.jumin_no2.value == "")){
			alert("주민번호는 반드시 있어야 합니다.");
			document.form_main.jumin_no1.focus();
			return;
		}
		
		 if(checkStrLen(form_main.jumin_no1, 6, "주민번호") == false){
            form_main.jumin_no1.focus();
            return;
        } 

		 if(checkStrLen(form_main.jumin_no2, 7, "주민번호") == false){
            form_main.jumin_no2.focus();
            return;
        } 

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
		if((document.form_main.post_cd1.value == "") || (document.form_main.post_cd2.value == "")){
			alert("우편번호는 반드시 있어야 합니다.");
			document.form_main.post_cd1.focus();
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
		
		if(document.form_main.photo_path.value != ""){
			var vafile = document.form_main.photo_path.value.substr(document.form_main.photo_path.value.length - 4, document.form_main.photo_path.value.length);
			if((vafile.toLowerCase() != ".gif") && (vafile.toLowerCase() != ".jpg") &&
			   (vafile.toLowerCase() != ".bmp") && (vafile.toLowerCase() != ".jpeg")){
				alert("사진파일은 확장명이 .gif, .jpg .jpeg .bmp 만 등록할 수 있습니다.==" + vafile);
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
          
        if(checkStrLen(form_main.remark, 500, "비고") == false){
            form_main.remark.focus();
            return;
        }
        
        if (OnValidationSubmit() == false){
        	return;	
        }
        
		document.form_main.submit();				
	}
	
	function selectZipCd(varZipCd1, varZipCd2, varAddr1)
	{
		var frm = document.form_main;
		frm.post_cd1.value = varZipCd1;
		frm.post_cd2.value = varZipCd2;
		frm.juso1.value = varAddr1;
	}

	function init()
	{
	
		// 필수입력
		define('jumin_no1', 'num', '주민등록번호', 6,6);	
		define('jumin_no2', 'num', '주민등록번호', 7,7);	
		define('office_tel1', 'num', '사무실전화번호', 2,3);	
		define('office_tel2', 'num', '사무실전화번호', 3,4);	
		define('office_tel3', 'num', '사무실전화번호', 4,4);	
		define('fax_no1', 'num', '팩스번호', 2,3);	
		define('fax_no2', 'num', '팩스번호', 3,4);	
		define('fax_no3', 'num', '팩스번호', 4,4);	
		define('cphone2', 'num', '핸드폰', 3,4);	
		define('cphone3', 'num', '핸드폰', 4,4);	
		define('post_cd1', 'num', '우편번호', 3,3);	
		define('post_cd2', 'num', '우편번호', 3,3);	
	}
</script>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="init()">
<%@ include file="/forum/common/CheckSessionPop.jsp" %>
<%@ include file="userinfo/SelectUserInfoProc.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<form name="form_main" method="post" action="./userinfo/CreatePerInfoPopProc.jsp" enctype="multipart/form-data">  
<input type="hidden" name="user_kind" value="<%=strUserKind%>">        
<input type="hidden" name="offisign_flag" value="<%=strOffisignFlag%>">              
  <tr align="left" valign="top">
    <td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="14">&nbsp;</td>
          <td width="386" height="25" valign="middle"><span class="soti_reqsubmit"><img src="../image/mypage/icon_mypage_soti.gif" width="9" height="9" align="absmiddle"> 
            </span><span class="soti_mypage">후임자 등록</span></td>
        </tr>
        <tr valign="top">
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr>
                <td width="14">&nbsp;</td> 
                <td height="30" align="left" valign="top"><table width="680" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td height="2" colspan="4" class="td_mypage"></td>
                    </tr>
                    <tr>
<%
	if(strPhotoPath.length()  < 1){
%>                    
                      <td colspan="2" rowspan="11" align="center" class="td_gray2">등록된<br>
                        사진이<br>
                        없습니다</td>
<%
	}else{
%>
                      <td colspan="2" rowspan="11" align="center" class="td_gray2" height="150" width="200">
					    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="border01" height="100%">
                          <tr> 
                            <td align="center" valign="middle" width="200" height="150"><img src="<%=strPhotoPath%>" width="150" height="120"></td>
                          </tr>
                        </table> 
					  </td>
<%
	}
%>
                      <td height="25" class="td_gray1" width="150" ><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        기관명</td>
<%
	if(strSessInOutGbn.equals("X")){ //담당업무는 외부사용자에게만 보여집니다.
%>                                    
					  <td height="25" class="td_lmagin" width="330"><%=strOrganNm%></td>		                      
<%
	}else{
%>
					  <td height="25" class="td_lmagin" width="330"><%=strHighOrganNm%></td>	
<%
	}
%>
					</tr>
                    <tr class="tbl-line"> 
                      <td width="22%" height="1"></td>
                      <td width="50%" height="1"></td>
                    </tr>
                    <tr> 
                      <td height="25"  width="150" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        대표자여부</td>
                      <td height="25" class="td_lmagin" width="330">  
                        <input type="radio" name="rep_yn" value="0" disabled <%=strRepFlagY%>>
                        대표자&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                        <input type="radio" name="rep_yn" value="1" disabled <%=strRepFlagN%>>
                        일반
                      </td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1" width="150" ><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        이름<strong>*</strong></td>
                      <td height="25" class="td_lmagin" width="330">
                        <input name="user_nm" maxlength="6"  type="text" class="textfield" style="WIDTH: 180px" value="<%=strUserNm%>"  >
                        
                      </td>  
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
                    <tr>
                      <td height="25" class="td_gray1" width="150" ><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        주민등록번호<strong>*</strong></td>
                      <td height="25" class="td_lmagin" width="330">
                        <input name="jumin_no1" maxlength="6"  type="text" class="textfield" style="WIDTH: 65px" value="<%=strJuminNo1%>"  >-
                        <input name="jumin_no2"  maxlength="7"  type="text" class="textfield" style="WIDTH: 65px" value="<%=strJuminNo2%>"  >
                      </td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="1" colspan="2"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1" width="150"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        부서명</td>
                      <td height="25" class="td_lmagin" width="330"> 
<%
	if(strSessInOutGbn.equals("X")){ //담당업무는 외부사용자에게만 보여집니다.
%>                          
						<input name="dept_nm" type="text" class="textfield" style="WIDTH: 180px" value="<%=strDeptNm%>"  >
<%
	}else{
%>
						<input name="dept_nm" type="text" class="textfield" style="WIDTH: 180px" value="<%=strOrganNm%>"  readonly>
<%
	}
%>
					  </td>
                    </tr>
                    <tr> 
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1" width="150" ><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        e-mail<strong>*</strong></td>
                      <td height="25" class="td_lmagin" width="330"><input name="email" type="text" class="textfield" style="WIDTH: 180px" value="<%=strEmail%>"  maxlength="30"></td>
                    </tr>
                    <tr> 
                      <td height="1" colspan="4" class="tbl-line"></td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td width="9%" height="1"></td>
                      <td width="19%" height="1"></td>
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
                    <tr> 
                      <td rowspan="5" align="center" class="td_gray2">전<br>
                        화<br>
                        번<br>
                        호</td>
                      <td height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        사무실<strong>*</strong></td>
                      <td height="25" colspan="2" class="td_lmagin"><input name="office_tel1" type="text" maxlength="4" class="textfield" style="WIDTH: 30px"  value="<%=strOfficeTel1%>"  >
                        - 
                        <input name="office_tel2" type="text" maxlength="4" class="textfield" style="WIDTH: 30px" value="<%=strOfficeTel2%>" >
                        - 
                        <input name="office_tel3" type="text" maxlength="4" class="textfield" style="WIDTH: 40px" value="<%=strOfficeTel3%>" ></td>
                    </tr>
                    <tr> 
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                    </tr>
                    <tr> 
                      <td height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        FAX<strong>*</strong></td>
                      <td height="25" colspan="2" class="td_lmagin"><input name="fax_no1" type="text" maxlength="4" class="textfield" style="WIDTH: 30px" value="<%=strFaxNo1%>" >
                        - 
                        <input name="fax_no2" type="text" maxlength="4" class="textfield" style="WIDTH: 30px" value="<%=strFaxNo2%>" >
                        - 
                        <input name="fax_no3" type="text" maxlength="4" class="textfield" style="WIDTH: 40px" value="<%=strFaxNo3%>" ></td>
                    </tr>
                    <tr> 
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                    </tr>
                    <tr> 
                      <td height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        이동통신번호<strong>*</strong></td>
                      <td height="25" colspan="2" class="td_lmagin">
                        <select name="cphone1" class="select">
                          <option <%=strCphone1_010%> value="010">010</option>
                          <option <%=strCphone1_011%> value="011">011</option>
                          <option <%=strCphone1_016%> value="016">016</option>
                          <option <%=strCphone1_017%> value="017">017</option>
                          <option <%=strCphone1_018%> value="018">018</option>
                          <option <%=strCphone1_019%> value="019">019</option>
                        </select>
                        - 
                        <input name="cphone2" type="text"  maxlength="4" class="textfield" style="WIDTH: 30px" value="<%=strCphone2%>" >
                        - 
                        <input name="cphone3" type="text"  maxlength="4" class="textfield" style="WIDTH: 40px" value="<%=strCphone3%>" ></td>
                    </tr>
                    <tr> 
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                    </tr>
                    <tr> 
                      <td rowspan="5" align="center" class="td_gray2">근<br>
                        무<br>
                        지 </td>
                      <td height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        우편번호<strong>*</strong></td>
                      <td height="25" colspan="2" class="td_lmagin"><input name="post_cd1" type="text" maxlength="3" class="textfield" style="WIDTH: 30px" value="<%=strPostCd1%>"  >
                        - 
                        <input name="post_cd2" type="text" maxlength="3" class="textfield" style="WIDTH: 30px" value="<%=strPostCd2%>" > 
                        <img src="../image/button/bt_searchZipCode.gif" width="96" height="19" align="absmiddle" style="cursor:hand" onclick="winopen('/common/SearchZipCodePop.jsp','SearchZipCodePop','height=450,width=520,scrollbars=yes,resize=yes')"> 
                      </td>
                    </tr>
                    <tr> 
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                    </tr>
                    <tr> 
                      <td height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        기본주소<strong>*</strong></td>
                      <td height="25" colspan="2" class="td_lmagin"><input name="juso1" type="text" class="textfield" style="WIDTH: 300px" value="<%=strJuso1%>"  maxlength="100"></td>
                    </tr>
                    <tr> 
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                    </tr>
                    <tr> 
                      <td height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        상세주소<strong>*</strong></td>
                      <td height="25" colspan="2" class="td_lmagin"><input name="juso2" type="text" class="textfield" style="WIDTH: 300px" value="<%=strJuso2%>"  maxlength="100"></td>
                    </tr>
                    <tr> 
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                    </tr>
                    <tr> 
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                    </tr>
                    <tr> 
                      <td height="25" colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        사진등록</td>
                      <td height="25" colspan="2" class="td_lmagin" onMouseover="showtip(this,event,'사진크기:공무원증(가로 5cm * 세로 4cm )')" onMouseout="hidetip()">
                        <input name="photo_path" type="file" class="textfield" style="WIDTH: 220px" >
                        &nbsp<a href="javascript:fun_view()"><img src="/image/button/bt_preview_icon.gif" width="71" height="19" align="absmiddle" style="cursor:hand"  border="0"></a>
                      </td>
                    </tr>
                    <tr> 
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                    </tr>
                    <tr> 
                      <td height="65" colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        자기소개</td>
                      <td height="65" colspan="2" class="td_box" ><textarea name="remark" wrap="hard" class="textfield" style="WIDTH: 100% ; height: 60"><%=strRemark%></textarea></td>
                    </tr>
                    <tr> 
                      <td height="2" class="tbl-line"></td>
                      <td height="2" class="tbl-line"></td>
                      <td height="2" class="tbl-line"></td>
                      <td height="2" class="tbl-line"></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td width="14">&nbsp;</td>
                <td height="30" align="left" valign="top"><table width="680" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td height="40" align="right"><a href="javascript:fun_create()"><img src="../image/button/bt_save.gif" width="43" height="20" border="0"></a>&nbsp;<a href="javascript:self.close()"><img src="../image/button/bt_cancel.gif" width="43" height="20" border="0"></a> 
                        <div align="right"></div></td>
                    </tr>
                  </table></td>
              </tr>
              <tr align="right"> 
                <td height="25" colspan="2" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="../image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
              </tr>
              <tr> 
                <td height="15" align="left" valign="top"></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
</form>
</table>
</body>
</html>
