<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SMemReqInfoViewForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SCommRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
 	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	SMemReqInfoViewForm objParams = new SMemReqInfoViewForm();  
	SMemReqInfoDelegate objReqInfo = new SMemReqInfoDelegate();
	AnsInfoDelegate objAnsInfo = new AnsInfoDelegate();

  	boolean blnParamCheck = false;
  	blnParamCheck = objParams.validateParams(request);
  	if(blnParamCheck == false){
  		System.out.println("Param Check Error ");
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg(objParams.getStrErrors());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
  	}

	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();
 	ResultSetSingleHelper objInfoRsSH = null;	/**요구 정보 상세보기 */
	ResultSetHelper objRs = null;				/** 답변정보 목록 출력*/
	String strReqID = (String)objParams.getParamValue("ReqID");
	SCommRequestBoxDelegate objReqBox2 = null; 		/**요구함 Delegate*/
	ResultSetSingleHelper objRsSH2 = null;			/** 요구함 상세보기 정보 */

	// 2004-06-04 
	String strAuditYear = (String)objParams.getParamValue("strAuditYear");
	String strReqBoxID = (String)objParams.getParamValue("ReqBoxID");
	String strReqOrganID = (String)objParams.getParamValue("ReqOrganID");
	System.out.println("strReqBoxID :"+strReqBoxID);
 	try{
		objReqBox2 = new SCommRequestBoxDelegate();
		objRsSH2 = new ResultSetSingleHelper(objReqBox2.getRecord(strReqBoxID, objUserInfo.getUserID()));

  		objInfoRsSH = new ResultSetSingleHelper(objReqInfo.getRecord(strReqID));
		objRs = new ResultSetHelper(objAnsInfo.getRecordList(strReqID));
	} catch(AppException objAppEx) {
		System.out.println("AppException : "+objAppEx.getMessage());
  		objAppEx.printStackTrace();
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>  	
<%  	
  		return;
	}
%>

<html>
<head>
<title><%=MenuConstants.REQ_BOX_MAKE%> > <%=MenuConstants.REQ_BOX_DETAIL_VIEW%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">

	/**답변정보 상세보기로 가기.*/
	function gotoDetail(strID){
		var f = document.formName;
		f.target = "popup";
		f.action = "/reqsubmit/common/SAnsInfoView.jsp?AnsID="+strID;
		f.WinType.value = "POPUP";
		NewWindow('/blank.html', 'popup', '520', '400');
		f.submit();
	}

	/** 목록으로 가기 */
	function gotoList(){
		var f = document.formName;  	
  		f.action="SNonReqList.jsp";
  		f.target = "";
  		f.submit();
	}

	// 추가 답변 작성 화면으로 이동
	function gotoAddAnsInfoWrite() {
		f = document.formName;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";		  
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp?AddAnsFlag=Y";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
	}
	
	// 답변 작성 화면으로 이동
  	function goSbmtReqForm() {
  		f = document.formName;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";		  
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}
  	
  	// 선택 답변 삭제
  	function selectDelete() {
  		var f = document.formName;
  		f.ReqID.value = "<%= strReqID %>";
  		f.target = "";
  		if (getCheckCount(f, "AnsID") < 1) {
  			alert("하나 이상의 체크박스를 선택해 주세요");
  			return;
  		}
  		f.action = "/reqsubmit/common/SAnsInfoDelProc.jsp";
  		if (confirm("선택하신 답변들을 삭제하시겠습니까?\n해당 답변들을 삭제하면 포함된 파일들도 일괄 삭제됩니다.")) f.submit();
  	}

	function sbmtReq() {
		f = document.formName;
		f.target = "";
		f.action = "/reqsubmit/common/SReqSubmtDoneProc.jsp";
		if (confirm("현재 요구에 대한 답변 제출을 완료하시겠습니까?")) f.submit();
	}

</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/reqsubmit/common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
		<%@ include file="/reqsubmit/common/MenuLeftReqsubmit.jsp" %>
	</td>
<!------- 2004-06-02 디자인 수정으로 인해 변경된 부분 시작 ------->
<td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr height="24" valign="top"> 
          <td height="24" colspan="2" align="left"><table width="789" height="24" border="0" cellpadding="0" cellspacing="0" bgcolor="DEEFCC">
              <tr>
                <td height="24"></td>
              </tr>
            </table></td>
        </tr>
<!------- 2004-06-02 디자인 수정으로 인해 변경된 부분 끝 ------->
        <tr valign="top"> 
          <td width="30" align="left"><img src="/image/common/bg_leftBody.gif" width="30" height="1"></td>
          <td align="left">
          <table width="759" border="0" cellspacing="0" cellpadding="0">
<form name="formName" method="post" action="<%=request.getRequestURI()%>"><!--요구함 신규정보 전달 -->
			<%
				//요구 정보 정렬 정보 받기.
				String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
				String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
				//요구 정보 페이지 번호 받기.
				String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");					
		    %>
		    <input type="hidden" name="ReqBoxID" value="<%= objInfoRsSH.getObject("REQ_BOX_ID") %>">
		    <input type="hidden" name="ReqID" value="<%= strReqID %>">

		    <!-- 2004-06-04 요구기관ID 및 감사년도 파라미터 설정 -->
		    <input type="hidden" name="ReqOrganID" value="<%= strReqOrganID %>">
		    <input type="hidden" name="AuditYear" value="<%= strAuditYear %>">
    
			<input type="hidden" name="ReqInfoSortField" value="<%=objParams.getParamValue("ReqInfoSortField")%>"><!--요구정보 목록정렬필드 -->
			<input type="hidden" name="ReqInfoSortMtd" value="<%=objParams.getParamValue("ReqInfoSortMtd")%>"><!--요구정보 목록정령방법-->
			<input type="hidden" name="ReqInfoQryField" value="<%=objParams.getParamValue("ReqInfoQryField")%>"><!--요구정보 조회 필드-->
			<input type="hidden" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"><!--요구정보 조회어-->
			<input type="hidden" name="ReqInfoPage" value="<%=objParams.getParamValue("ReqInfoPage")%>"><!--요구정보 페이지 번호 -->
			<input type="hidden" name="ReqInfoID" value="<%=objParams.getParamValue("ReqID")%>"><!--요구정보 ID-->
			<input type="hidden" name="AnsInfoID" value=""><!--답변정보ID -->
			<input type="hidden" name="ReqStt" value="<%=objInfoRsSH.getObject("REQ_STT")%>">
			
			<input type="hidden" name="WinType" value="SELF">

			<!-- 2004-06-08 kogaeng 깜빡하고 ReturnURL을 빠뜨렸었다. -->
			<input type="hidden" name="ReturnURL" value="<%=request.getRequestURI()%>?ReqBoxID=<%= objInfoRsSH.getObject("REQ_BOX_ID") %>&ReqID=<%= strReqID %>">
             
            <tr> 
                <td height="23" align="left" valign="top"></td>
             </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="35%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- 타이틀을 입력해 주세요 ------------------------>
                      		<span class="title"><%= MenuConstants.REQ_INFO_LIST_SUBMT_NONE %></span><strong>-<%=MenuConstants.REQ_INFO_DETAIL_VIEW%></strong>
                      </td>
                      <td width="6%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- 현재 위치 정보를 기술한답니다. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <B><%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- 현재 페이지에 대한 설명 기술 ------------------------>
                		   아직 답변 제출이 완료되지 않은 요구의 상세 정보를 조회하실 수 있습니다.
                </td>
              </tr>
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="soti_reqsubmit">
                	<!-------------------- TAB 에 해당하는 제목을 기술하는 곳이지요. ------------------------>
                	<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                  요구 정보
                </td>
              </tr>
              <tr> 
                <td align="left" valign="top" class="soti_reqsubmit">
                <!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 시~~~작 ------------------------->
                <table width="680" border="0" cellspacing="0" cellpadding="0">
                    <tr class="td_reqsubmit"> 
                      <td width="110" height="2"></td>
                      <td height="2" colspan="3" width="570"></td>
                    </tr>
                    
                    <tr> 
                      <td height="25" class="td_gray1"width="110"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        요구제목 </td>
                      <td height="25" colspan="3" class="td_lmagin" width="570" style="padding-top:5px;padding-bottom:5px">
                      	<B><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%></B>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>                    
                    <tr> 
                      <td height="25" class="td_gray1" width="110"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        요구내용 </td>
                      <td colspan="3" class="td_lmagin" width="570" style="padding-top:5px;padding-bottom:5px">
                      	<%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%>
                      </td>
                    </tr>
                    <tr height="1" bgcolor="#d0d0d0"> 
                      <td height="1" colspan="4"></td>
                    </tr>   
                    <tr height="1" bgcolor="#ffffff"> 
                      <td height="1" colspan="4"></td>
                    </tr>   
                    <tr height="1" bgcolor="#d0d0d0"> 
                      <td height="1" colspan="4"></td>
                    </tr>   
                    
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        요구함명 </td>
                      <td colspan="3" class="td_lmagin">
                      	<%=objInfoRsSH.getObject("REQ_BOX_NM")%>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr> 
                      <td width="110" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        요구기관 </td>
                      <td class="td_lmagin" width="230">
                      	<%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%> (<%=(String)objInfoRsSH.getObject("USER_NM")%>)
                      </td> 
                      <td class="td_gray1" width="110"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        제출기관 </td>
                      <td class="td_lmagin" width="230">
                      	<%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        공개등급 </td>
                      <td class="td_lmagin">
                      	<%= CodeConstants.getOpenClass((String)objInfoRsSH.getObject("OPEN_CL")) %>
                      </td>
                      <td class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        첨부파일 </td>
                      <td height="25" class="td_lmagin" width="220">
                      	<%=StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID"))%>
                      </td> 
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>                                                         
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        제출기한 </td>
                      <td class="td_lmagin">
                      	<%= StringUtil.getDate((String)objInfoRsSH.getObject("SUBMT_DLN")) %> 24:00
                      </td>
                      <td class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        요구일자 </td>
                      <td class="td_lmagin">
                      	<%=StringUtil.getDate2((String)objInfoRsSH.getObject("REG_DT"))%>
                      </td> 
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>                                                                             
                </table>
				<!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 끝 ------------------------->                   
                </td>
              </tr>
              <tr>
               	<!-- 스페이스한칸 -->
               	<td>&nbsp;</td>
               	<!-- 스페이스한칸 -->
              </tr>
              <tr>
               	<td>
               	 <table border="0">
               	   <tr>
               		 <td>
					<img src="/image/button/bt_viewReqHistory.gif"  height="20" border="0" onClick="viewReqHistory('<%= strReqID %>')" style="cursor:hand"  alt="현재 요구의 처리과정을 일자별로 조회합니다">
						<img src="/image/button/bt_listReqInfo.gif"  height="20" border="0" onClick="gotoList()" style="cursor:hand" alt="미제출 요구 목록 조회 화면으로 이동합니다.">
               		 </td>
               	   </tr>
               	</table>   
                </td>
              </tr>               
              <tr>
               	<!-- 스페이스한칸 -->
               	<td>&nbsp;</td>
               	<!-- 스페이스한칸 -->
              </tr>
              <tr> 
                <td height="30" class="soti_reqsubmit">
                	<!-------------------- TAB 에 해당하는 제목을 기술하는 곳이지요. ------------------------>
                	<table border="0" cellpadding="0" cellspacing="0" width="759">
                		<tr>
                			<td width="400" class="soti_reqsubmit">
                			   <img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                  				답변 목록
				            </td>
				            <td width="359" align="right" valign="bottom" class="text_s">
				            	<!------------------------- COUNT (PAGE) ------------------------------------>
				            	&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle">
				            	전체 자료 수 : <%= objRs.getRecordSize() %>개 &nbsp;&nbsp;
				            </td>
				       </tr>
				   </table>
                </td>
              </tr>              
              <tr> 
                <td align="left" valign="top" class="soti_reqsubmit">
                <!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 시~~~작 ------------------------->
					<table width="759" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td height="2" class="td_reqsubmit"></td>
	                    </tr>
	                    <tr align="center" class="td_top">
	                    	<td>
	                    		<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr class="td_top">
										<td align="center" width="20"><input type="checkbox" name="checkAll" value="" onClick="javascript:checkAllOrNot(this.form)"></td>
										<td height="22" width="39" align="center">NO</td>
										<td width="350" align="center">제출의견</td>
										<td width="100" align="center">작성자</td>
										<td width="60" align="center">공개</td>
										<td width="120" align="center">답변</td>
										<td width="70" align="center">답변일</td>
									</tr>
	                    		</table>
	                    	</td>
	                    </tr>
                	    <tr> 
                    	  	<td height="1" class="td_reqsubmit"></td>
                    	</tr>
						<%
							int intRecordNumber=1;
						  	String strAnsInfoID="";
						  	if (objRs.getRecordSize() > 0) {
							  	while(objRs.next()){
							   		 strAnsInfoID = (String)objRs.getObject("ANS_ID");
						 %>								
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
							<td>
								<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="20" align="center"><input type="checkbox" name="AnsID" value="<%= strAnsInfoID %>"></td>
										<td height="22" width="39" align="center"><%=intRecordNumber%></td>
										<td width="350" class="td_lmagin"><a href="JavaScript:gotoDetail('<%=strAnsInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
										<td width="100" align="center"><%=(String)objRs.getObject("USER_NM")%></td>
										<td width="60" align="center"><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
										<td width="120" align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
										<td width="70" align="right" style="padding-top:2px;padding-bottom:2px"><%=StringUtil.getDate2((String)objRs.getObject("ANS_DT"))%></td>
									</tr>
								</table>
							</td>
						</tr>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       	
						<%
								    intRecordNumber ++;
								}//endwhile
							} else {
								out.println("<tr><td align='center' height='30'>등록된 답변이 없습니다.</td></tr>");
							}
						%>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       	
	                </table>
	                <p>
	                <%
						String strReqStt = (String)objInfoRsSH.getObject("REQ_STT");
						if (CodeConstants.REQ_STT_NOT.equalsIgnoreCase(strReqStt)) {
					%>
							<img src="/image/button/bt_makeAnswer2.gif" border="0" onClick="javascript:javascript:goSbmtReqForm()" style="cursor:hand"  alt="요구에 대한 답변을 작성합니다.">
					<% } else { %>
						<img src="/image/button/bt_registerAddAnswer.gif" border="0" onClick="javascript:javascript:gotoAddAnsInfoWrite()" style="cursor:hand" alt="추가 요구에 대한 답변을 등록합니다">
							<input type="hidden" name="AddAnsFlag" value="Y">
					<% } %>
					<img src="/image/button/bt_delSelect.gif" border="0" onClick="javascript:selectDelete()" style="cursor:hand" alt="선택된 답변을 삭제합니다.">
					<% 					
					if(!strReqSubmitFlag.equals("004") && !CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase((String)objInfoRsSH.getObject("REQ_STT")) && objRs.getRecordSize() > 0) {
					%>
							<img src="/image/button/bt_reqEnd2.gif" border="0" onClick="javascript:sbmtReq()" style="cursor:hand" alt="답변이 등록된 요구를 즉시 요구기관으로 제출합니다.">
					<%
						}
					%>
				<p><br></p>
				<!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 끝 ------------------------->
				</td>
			  </tr>
</form>
          </table>
          </td>
        </tr>
    </table>
    <!--------------------------------------- 여기까지  MAIN WORK AREA 실제 코딩의 끝입니다. ----------------------------->      
    </td>
  </tr>
</table>
<%@ include file="/common/Bottom.jsp" %>
</body>
</html>