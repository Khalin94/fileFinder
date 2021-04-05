<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="nads.dsdm.app.common.zipinfo.ZipInfoDelegate"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean"
	scope="request" />
<%
	// 화면에 입력한 동
	String strDong = nads.lib.reqsubmit.util.StringUtil
			.getNoTagStr(StringUtil.getNVLNULL(request
					.getParameter("strDong")));
	String strdoro = nads.lib.reqsubmit.util.StringUtil
			.getNoTagStr(StringUtil.getNVLNULL(request
					.getParameter("doro")));
	String strsidoNm = nads.lib.reqsubmit.util.StringUtil
			.getNoTagStr(StringUtil.getNVLNULL(request
					.getParameter("sidoNm")));
	String strsiggNm = nads.lib.reqsubmit.util.StringUtil
			.getNoTagStr(StringUtil.getNVLNULL(request
					.getParameter("siggNm")));

	// 현재 페이지 번호
	String strCurrentPage = nads.lib.reqsubmit.util.StringUtil
			.getNoTagStr(StringUtil.getNVL(
					request.getParameter("strCurrentPage"), "1"));

	// 페이지당 row의 갯수
	String strCountPerPage;

	try {
		Config objConfig = PropertyConfig.getInstance();
		strCountPerPage = objConfig.get("page.rowcount");
	} catch (ConfigException objConfigEx) {
		strCountPerPage = StringUtil.getNVL(
				request.getParameter("strCountPerPage"), "10");
	}

	// 우편번호 목록
	ArrayList objZipInfoLists = null;
	ArrayList objZipSidoLists = null;
	ArrayList objZipSiGunGuLists = null;
	int intTotalCount = 0;

	try {

		ZipInfoDelegate objZipInfoDelegate = new ZipInfoDelegate();
		Hashtable objParams = new Hashtable();

		//objZipInfoLists = objZipInfoDelegate.getZipInfoListPerPage(strCurrentPage, strCountPerPage, objParams);		
		
		System.out.println ("@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		if (strdoro != null && !strdoro.equals("")) {
			
		   
			if (strsidoNm != null && !strsidoNm.equals("")) {
				objParams.put("SIDO", strsidoNm);
				objParams.put("GUGUN", strsiggNm);
				objParams.put("DORO_NM", strdoro);
		
				objZipInfoLists = objZipInfoDelegate
						.getDoRoZipCode1(objParams);
			} else {
				objParams.put("DORO_NM", strdoro);
			  
				objZipInfoLists = objZipInfoDelegate
						.getDoRoZipCode2(objParams);
			}
		} else {
			strdoro = "도로명 + 건물번호를 입력하세요.";
		}
		  
		objZipSidoLists = objZipInfoDelegate.getZipSido();
		objZipSiGunGuLists = objZipInfoDelegate.getZipSiGunGu();

		System.out.println(" objZipSidoLists : "
				+ objZipSidoLists.size());
		System.out.println(" objZipSiGunGuLists : "
				+ objZipSiGunGuLists.size());
	} catch (AppException objAppEx) {

		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());

		// 에러 발생 메세지 페이지로 이동한다.
%>
<jsp:forward page="../common/message/ViewMsg.jsp" />
<%
	return;

	}

	if (objZipInfoLists == null) {
		intTotalCount = 0;
	} else {
		intTotalCount = objZipInfoLists.size();
	}
%>

<html>
<head>
<title>우편번호 찾기</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/formchek.js"></script>
<script language="JavaScript" type="text/JavaScript">
<!--

var arr_sido = new Array();
var arr_sigg = new Array();

<%Hashtable objzipsidohashdata = new Hashtable();
			Hashtable objzipsigunguhashdata = new Hashtable();
			int k = 0;
			for (int i = 0; i < objZipSidoLists.size(); i++) {
				objzipsidohashdata = (Hashtable) objZipSidoLists.get(i);%>
	arr_sido[<%=i + 1%>] = '<%=objzipsidohashdata.get("SIDO")%>';
	arr_sigg[<%=i + 1%>] = new Array();
<%for (int j = 0; j < objZipSiGunGuLists.size(); j++) {
					objzipsigunguhashdata = (Hashtable) objZipSiGunGuLists
							.get(j);
					if (((String) objzipsidohashdata.get("SIDO"))
							.equals((String) objzipsigunguhashdata.get("SIDO"))) {%>	
	arr_sigg[<%=i + 1%>][<%=k%>] = '<%=objzipsigunguhashdata.get("GUGUN")%>';
<%k = k + 1;
					}
				}
				k = 0;
			}%>

function Close(){
	self.close();
}
function setCurrPage(varCurrPage) {
	document.frm1.strCurrentPage.value = varCurrPage;
}
function goPage(varCurrPage) {
	if (isSearch()) {
		setCurrPage(varCurrPage);
		document.frm1.submit();
	}
}
function selectZipCd(varZipCd1, varZipCd2, varAddr1) {
	if (opener != null) {
		opener.selectZipCd(varZipCd1, varZipCd2, varAddr1);
	}
}
function goSearch() {
	//if (isSearch()) {
		document.frm1.submit();
	//}
}
function isSearch() {

	// 우편번호 동을 입력했는지 확인한다.
	if ( !isValidatestrDong() ) {
		return false;
	}
	return true;

}
function isValidatestrDong() {
	if (isWhitespace(document.frm1.strDong.value)) {
		alert("우편번호의 동을 입력하십시요!");
		return false;
	}
	return true;
}

// 2015-04-30 수정 전
//function clear_if(arg){
//    
//    arg.value = "";
//    arg.onfocus = null;
//}

// 2015-04-30 수정 후
function clear_if(arg){
	
    if(arg.value == "도로명 + 건물번호를 입력하세요.")
	arg.value = "";
	arg.onfocus = null;
}

function selectedSiggList(obj)
{
    document.frm1.sidoNm.value = obj.value;
     
    var obj_sigg = document.frm1.selSigg;   
 
    for(var t=obj_sigg.options.length-1; t>0; t--) {
    	obj_sigg.options[t] = null;
    }
    
    var var_sigg_nm;
    var org_siggNm = document.frm1.siggNm.value;
    if(obj.selectedIndex > 0) {
 
 
         document.frm1.siggNm.value = "";
         obj_sigg.options[0] = new Option("===== 전체 =====" ,"");
         for(var s=0 ; s < arr_sigg[obj.selectedIndex].length ; s++) {
    
        	var_sigg_nm = arr_sigg[obj.selectedIndex][s];
        	obj_sigg.options[s+1] = new Option(var_sigg_nm , var_sigg_nm);
    
            if(var_sigg_nm == org_siggNm)
            {
                obj_sigg.options[s+1].selected = true;
                document.frm1.siggNm.value = var_sigg_nm;
            } else {
            	obj_sigg.options[s+1].selected = false;
            }
            
        }
               
    }
    
}
 
function clearBG(){
	var ulList = document.getElementById("road_search").childNodes;
    if(ulList.length > 0) {
        for(i=0; i<ulList.length ; i++) {
        	if(ulList.item(i).tagName == "LI"){
        		ulList.item(i).runtimeStyle.cssText='background-color:#FFFFFF;';
        	}
        }
    }
}
//앞뒤공백제거
function trim(str) {
  return str.replace(/^\s+/g, '').replace(/\s+$/g, '');
}
function isValid() {
    
    var input = document.frm1.txtRoad;
    var inputCntChk = input.value.indexOf(" ");
    var lastchr = input.value.substr(trim(input.value).length-1);
    var sidoNm = document.frm1.sidoNm.value;
    var siggNm = document.frm1.siggNm.value;
 
    if (isNull( input ) || input.value == first_txt) {
        alert("도로명 또는 도로명+건물번호 를  입력하십시오.");
        first_search = 1;
        input.focus();
        return false;
    } else if ( !chkValidInput( input ) ) {
        alert("입력란에 특수문자를 사용할 수 없습니다.");
        input.focus();
        return false;
    } 
 
    //도로명만 검색할 경우
    if ( inputCntChk <= 0 || (inputCntChk > 0 && isNaN(lastchr)) ) {
    	if ( sidoNm == null || sidoNm == "" ||  (sidoNm != "세종특별자치시" && siggNm == null) || (sidoNm != "세종특별자치시" && siggNm == "") ) { 
    		alert("도로명주소 검색 시 건물번호를 입력하지 않으면, \n 시도 및 시군구를 선택하고 조회하셔야 합니다.");
            input.focus();
            return false;
    	}
    } 
    
 
    document.frm1.method = "post";
    document.frm1.submit();
  
}

 
function isNull( input ) {
    if ( input.value == null || input.value == "") {
        return true;
    }
    return false;
}
 
function chkValidInput( input ) {
    var arr = new Array("\(", "\)", "\[", "\] ", "\{", "\}", "\<", "\>", "\"", "\'", "\`", "\~", "$", "\!", "\#", "\%", "\^", "\&", "\@", "\,", "\.", "\;", "\:", "\\", "\/", "\|", "\*", "\=", "\?" );
 
    var rtn = true;
 
    for ( var i=0; i < arr.length; i++)
    {
        if ( input.value.indexOf(arr[i]) >= 0 )
        {
            return false;
        }
    }
    return rtn;
}
 
function setSiggNm(obj)
{
    document.frm1.siggNm.value = obj.value;
}
function goJibunZipcd() {
    var frm = document.frm1;
    frm.method.value = "post";
    frm.action = "/common/SearchZipCodePop2.jsp";
    frm.submit();
}
function goRoadZipcd() {
    var frm = document.frm1;
    frm.method.value = "post";
    frm.action= "/common/doro.jsp";
    frm.submit();  
}
function linkJusoGoKr() {
    window.open("http://www.juso.go.kr/openSearchPageJibun.do","_jusogokr_s","toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=446,height=675");
}
function clearTxt(obj) {
    if(obj.value == first_txt) {
        obj.value = "";
    }
}
 
 
function checkAddrGubun(obj){
    e1 =    document.getElementById("v_gubun_value");
    e1.value = obj.value;
}
 
function openWhatIsBldgCd() {
 
    window.open("/popup/what_is_bldgcd.jsp","_whatisbldgcd","toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=354,height=191");
}
  
 
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"
	onload="selectedSiggList(document.frm1.selSido);">
	<table width="470" border="0" cellspacing="0" cellpadding="0">
		<tr class="td_join">
			<td height="5"></td>
			<td height="5"></td>
		</tr>
		<tr>
			<td height="10"></td>
			<td height="10"></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td height="25" valign="middle"><img
				src="../image/join/icon_join_soti.gif" width="9" height="9"
				align="absmiddle"> <span class="soti_join"> 우편번호 찾기</span></td>
		</tr>
		<tr height="14">
			<td height="14"></td>
			<td height="14"></td>
		</tr>
		<tr height="14">
			<td height="14"></td>
			<td height="14">
		    <!-- 2015.04.23 수정 전 
			<a href="javascript:goJibunZipcd();">
			<img src="/images/main/tabs_ji_off.gif" alt="지번주소검색" align="absmiddle" style="border: none" /></a>
			<a href="javascript:goRoadZipcd();">
			<img src="/images/main/tabs_do_on.gif" alt="도로명주소검색" align="absmiddle" style="border: none" /></a>
			 -->
			 <!-- 2015.04.23 수정 후 -->
			<a href="javascript:goRoadZipcd();">
            <img src="/images/main/tabs_do_on.gif" alt="도로명주소검색" align="absmiddle" style="border: none" /></a>
            <a href="javascript:goJibunZipcd();">
            <img src="/images/main/tabs_ji_off.gif" alt="지번주소검색" align="absmiddle" style="border: none" /></a>
			 
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td height="2"><table width="97%" border="0" cellpadding="0"
					cellspacing="1" bgcolor="CCCCCC">
					<tr>
						<td height="45" align="center" bgcolor="#F3F3F3"><table
								width="97%" border="0" cellspacing="3" cellpadding="0">
								<form name="frm1" action="<%=request.getRequestURI()%>"
									method="post" onSubmit="return isSearch()">
									<input type="hidden" name="strCurrentPage" value="">
									<tr>
										<td align="left"><img
											src="../image/common/icon_nemo_gray.gif" width="3" height="6"
											align="absmiddle"> <strong>시도</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<select onchange="selectedSiggList(this)" name="selSido"
											id="selSido" title="시도 선택">
												<option value="">===== 전체 =====</option>
												<%
													Hashtable objzipsido = new Hashtable();
													String strsidocode = "";
													String strsidocodetemp = "";
													for (int i = 0; i < objZipSidoLists.size(); i++) {
														objzipsido = (Hashtable) objZipSidoLists.get(i);
														//strsidocode = (String)objzipsido.get("LAW_DONG_CD");
														//strsidocodetemp = strsidocode.substring(0,2);
												%>
												<option value="<%=objzipsido.get("SIDO")%>"
													<%if (strsidoNm.equals((String) objzipsido.get("SIDO"))) {%>
													selected <%}%>><%=objzipsido.get("SIDO")%></option>

												<%
													}
												%>
										</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>시군구</strong> <select
											onchange="setSiggNm(this)" name="selSigg" id="selSigg"
											title="시군구 선택">
												<option value="">===== 전체 =====</option>
										</select></td>
										<input type="hidden" name="sidoNm" id="sidoNm"
											value="<%=strsidoNm%>" />
										<input type="hidden" name="siggNm" id="siggNm"
											value="<%=strsiggNm%>" />
									</tr>
									<tr>
										<td align="left"><img
											src="../image/common/icon_nemo_gray.gif" width="3" height="6"
											align="absmiddle"> <strong>도로명</strong>
											&nbsp;&nbsp;&nbsp;  
                  <input type="text" size="30" name="doro" value="<%=strdoro%>" onfocus="clear_if(this)"> 
				  
											</select>&nbsp;&nbsp;&nbsp;<strong>
												<a href="javascript:goSearch();"> <img
													src="../image/button/bt_inquiry.gif" width="43" height="20"
													align="absmiddle" border=0></a>
										</strong></td>
									</tr>
									<tr>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td>※&nbsp;검색방법 : 도로명 + 건물번호<br> 예) 서울특별시 종로구 인사동4길
											5-24 (인사동)<br> - 도로명 : 인사동4길, 건물번호 : 5-24<br>
										</td>
									</tr>
									<input type="hidden" name="isRoad" id="isRoad" value='Y' /> <input
										type="hidden" name="roadStep" id="roadStep" value='' />
								</form>
							</table></td>
					</tr>
				</table></td>
		</tr>
		<tr>
			<td height="10"></td>
			<td height="10"></td>
		</tr>

		<%
			if (intTotalCount > 0) {
		%>
		<tr>
			<td width="14" height="20">&nbsp;</td>
			<td width="386" height="25">&nbsp;&nbsp;아래 목록에서 원하는 주소를
				Click하세요.</td>
		</tr>
		<tr>
			<td width="14">&nbsp;</td>
			<td height="23" align="left" valign="top"><table width="97%"
					border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top">
							<div style="overflow-y: scroll; width: 450; height: 200;">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td height="2" colspan="2" class="td_join"></td>
									</tr>

									<%
										Hashtable objRowInfos = new Hashtable(0);
											String strAddr1 = "";
											String strAddr2 = "";
											String strZipCd = "";
											String strZipCd1 = "";
											String strZipCd2 = "";
											String strTempdong = null;
											String strTempbdbun2 = null;
                                            System.out.println(objZipInfoLists.size() + "$$$$$$$$");
                                            System.out.println((Hashtable) objZipInfoLists.get(0) + "$$$$$$$$");
											for (int i = 0; i < objZipInfoLists.size(); i++) {
												objRowInfos = (Hashtable) objZipInfoLists.get(i);
												strZipCd = (String) objRowInfos.get("ZIP_CD");
												String[] arrZipCd = strZipCd.split("-");
												strZipCd1 = arrZipCd[0];
												strZipCd2 = arrZipCd[1];
												strTempdong = "";
												strTempbdbun2 = "";
												if (objRowInfos.get("EUPMYUNDONG") != null
														&& !((String) objRowInfos.get("EUPMYUNDONG"))
																.equals("")) {
													strTempdong = "("
															+ (String) objRowInfos.get("EUPMYUNDONG") + ")";
												}

												if (objRowInfos.get("BDBUN2") != null
														&& ((String) objRowInfos.get("BDBUN2")).equals("0")) {
													strTempbdbun2 = "";
												} else {
													strTempbdbun2 = "-"
															+ (String) objRowInfos.get("BDBUN2");
												}

												strAddr1 = (String) objRowInfos.get("SIDO") + " "
														+ (String) objRowInfos.get("GUGUN") + " "
														+ (String) objRowInfos.get("DORO_NM") + " "
														+ (String) objRowInfos.get("BDBUN1")
														+ strTempbdbun2 + " " + strTempdong;

												strAddr2 = (String) objRowInfos.get("SIDO") + " "
														+ (String) objRowInfos.get("GUGUN") + " "
														+ (String) objRowInfos.get("DORO_NM") + " "
														+ (String) objRowInfos.get("BDBUN1")
														+ strTempbdbun2;
									%>
									<tr align="center"
										onMouseOver="this.style.backgroundColor='#FCFDF0'"
										OnMouseOut="this.style.backgroundColor=''">
										<td width="19%" height="21"><%=objRowInfos.get("ZIP_CD")%></td>
										<td width="81%" height="21" align="left"><a
											href="javascript:selectZipCd('<%=strZipCd1%>', '<%=strZipCd2%>', '<%=strAddr2%>');Close();">
												<%=strAddr1%>
										</a></td>
									</tr>
									<tr>
										<td height="1" colspan="2" class="tbl-line"></td>
									</tr>
									<%
										}
									%>

								</table>
							</div>
						</td>
					</tr>
				</table></td>
		</tr>

		<%
			} else {
				out.println("<tr>");
				out.println("<td height='22' colspan='2' align='center'>해당 데이타가 없습니다.");
				out.println("</td>");
				out.println("</tr>");
				out.println("<tr class='tbl-line'>");
				out.println("<td height='1'></td>");
				out.println("<td height='1'></td>");
				out.println("</tr>");
			}
		%>

		<tr align="right">
			<td height="25" colspan="2" class="td_gray1">&nbsp;<a
				href="javascript:self.close()"><img
					src="../image/button/bt_close.gif" width="46" height="11"
					border="0"></a>&nbsp;&nbsp;
			</td>
		</tr>
	</table>
</body>
</html>