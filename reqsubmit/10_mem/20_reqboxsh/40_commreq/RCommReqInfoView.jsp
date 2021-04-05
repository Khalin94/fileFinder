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
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					파라미터 체크 Part 														  */
	/*************************************************************************************************/
	
	/**일반 요구 상세보기 파라미터 설정.*/
	CmtSubmtReqBoxVListForm objParams =new CmtSubmtReqBoxVListForm();  
	boolean blnParamCheck=false;
	/**전달된 파리미터 체크 */
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objParams.getStrErrors());
		//out.println("ParamError:" + objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}//endif

	/*************************************************************************************************/
	/** 					데이터 호출 Part 														  */
	/*************************************************************************************************/
	
	/*** Delegate 과 데이터 Container객체 선언 */
	CmtSubmtReqInfoDelegate  objReqInfo=null;	/** 요구정보 Delegate */
	ResultSetSingleHelper objInfoRsSH=null;		/**요구 정보 상세보기 */
	 
	ResultSetHelper objRs = null;
 
	try{
		/**요구 정보 대리자 New */    
		objReqInfo=new CmtSubmtReqInfoDelegate();
		/**요구정보 이용 권한 체크 */
		boolean blnHashAuth=objReqInfo.checkReqInfoAuth((String)objParams.getParamValue("ReqInfoID"),objUserInfo.getOrganID()).booleanValue(); 
		if(!blnHashAuth){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSAUTH-0001");
			objMsgBean.setStrMsg("해당 요구정보를  볼 권한이 없습니다.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		}else{
			objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("ReqInfoID")));
			objRs = new ResultSetHelper(objReqInfo.getRecordListToAnsInfo((String)objParams.getParamValue("ReqInfoID")));
		}/**권한 endif*/
	}catch(AppException objAppEx){
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
		objMsgBean.setStrCode("SYS-00010");//AppException에러.
		objMsgBean.setStrMsg(objAppEx.getMessage());
		//out.println("<br>Error!!!" + objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
%>

<html>
<head>
<title><%=MenuConstants.REQ_BOK_COMM_REQ%> > <%=MenuConstants.REQ_BOX_DETAIL_VIEW%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
  /**요구정보 수정페이지로 가기.*/
  function gotoEditPage(){
  	formName.action="./RCommReqInfoEdit.jsp";
  	formName.submit();
  }
  /**요구 정보 삭제 */
  function gotoDeletePage(){
  	if(confirm('선택하신 요구정보를 삭제하시겠습니까?')){
	  	formName.action="./RCommReqInfoDelProc.jsp";
  		formName.submit();  	
  	}
  }
  /** 목록으로 가기 */
  function gotoList(){
  	formName.action="./RCommReqVList.jsp";
  	formName.submit();
  }
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="../../../common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="../../../common/MenuLeftReqsubmit.jsp" %></td>
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
          <form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getRequestURI()%>"><!--요구함 신규정보 전달 -->
			<%//요구함 정렬 정보 받기.
			String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
			String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
			//요구함 페이지 번호 받기.
			String strReqBoxPagNum=objParams.getParamValue("ReqBoxPage");
			//요구함 조회정보 받기.
			String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
			String strReqBoxQryTerm=objParams.getParamValue("ReqBoxQryTerm");
			//요구 정보 정렬 정보 받기.
			String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
			String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
			//요구 정보 페이지 번호 받기.
			String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");					
		    %>
		     <%=objParams.getHiddenFormTags()%>
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="35%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- 타이틀을 입력해 주세요 ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_BOK_COMM_REQ%></span><strong>-<%=MenuConstants.REQ_INFO_DETAIL_VIEW%></strong>
                      </td>
                      <td width="6%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- 현재 위치 정보를 기술한답니다. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <B><%=MenuConstants.REQ_BOK_COMM_REQ%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- 현재 페이지에 대한 설명 기술 ------------------------>
                		위원회 제출신청함의 요구제목을 확인하는 화면입니다.
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
                      <td height="2" colspan="4"></td>
                    </tr>
                    
                    <tr> 
                      <td width="100" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        요구제목 </td>
                      <td width="580" colspan="3" class="td_lmagin">
                      	<B><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%></B>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>                    
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        요구내용 </td>
                      <td height="25" colspan="3" class="td_lmagin" style="padding-top:4px;padding-bottom:4px">
                      	<%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%>
                      </td>
                    </tr>
                    <tr height="1" bgcolor="#d0d0d0"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr height="1" bgcolor="#ffffff"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr height="1" bgcolor="#d0d0d0"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        소관 위원회 </td>
                      <td height="25" colspan="3" class="td_lmagin">
                      	<%=objInfoRsSH.getObject("CMT_ORGAN_NM")%>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>              
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        신청함명 </td>
                      <td height="25" colspan="3" class="td_lmagin">
                      	<%=objInfoRsSH.getObject("CMT_SUBMT_REQ_BOX_NM")%>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>
                    <tr> 
                      <td width="100" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        신청기관 </td>
                      <td height="25" width="240" class="td_lmagin">
                      	<%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%>
                      </td> 
                      <td height="25" width="100" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        제출기관 </td>
                      <td height="25" width="240" class="td_lmagin">
                      	<%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>
                    
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        공개등급 </td>
                      <td height="25" class="td_lmagin">
                      	<%=CodeConstants.getOpenClass((String)objInfoRsSH.getObject("OPEN_CL"))%>
                      </td>
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        제출양식파일</td>
                      <td height="25" class="td_lmagin">
                      	<%=StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID"))%>
                      </td> 
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>                                                         
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        등록자 </td>
                      <td height="25" class="td_lmagin">
                      	<%=(String)objInfoRsSH.getObject("REGR_NM")%>
                      </td>
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        등록일자 </td>
                      <td height="25" class="td_lmagin">
                      	<%=StringUtil.getDate2((String)objInfoRsSH.getObject("REG_DT"))%>
                      </td> 
                    </tr>
                    <tr height="2" class="tbl-line"> 
                      <td height="2" colspan="4"></td>
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
               	<!----------------------- 저장 취소등 Form관련 버튼 시작 ------------------------->
               	    <%
					  //신청함 진행 상태.
					  String strReqBoxStt=(String)objInfoRsSH.getObject("STT");                    
					%>
               	
               	 <table>
               	   <tr>
               		 <td>
						<%
							// 2005-09-26 kogaeng EDIT
							//신청함상태가 작성중(001), 상신대기(002), 위원회요구삭제(009)
							if(strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_001) || strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_002) || strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_009)){
						%>
						  <%
							/** 등록자와  로그인자가 같을때만 화면에 출력함.*/
							if(objUserInfo.getUserID().equals((String)objInfoRsSH.getObject("REGR_ID"))){
						  %>
						<img src="/image/button/bt_modifyReq.gif"  height="20" border="0" onClick="gotoEditPage()" style="cursor:hand">
						<img src="/image/button/bt_delReq.gif"  height="20" border="0" onClick="gotoDeletePage()" style="cursor:hand">
						  <%
							}//endif
						  %>												
					    <%	
						}//end if
						%>
						<img src="/image/button/bt_viewAppBox.gif"  height="20" border="0" onClick="gotoList()" style="cursor:hand">
               		 </td>
               	   </tr>
               	</table>   
               	<!----------------------- 저장 취소등 Form관련 버튼 끝 ------------------------->               	   
                </td>
              </tr>               
              <tr> 
				<td width="759" align="center">
					<table border="0" cellpadding="0" cellspacing="0">
						<tr>
						    <td width="400" height="30" align="left" class="soti_reqsubmit">
			                	<!	-------------------- TAB 에 해당하는 제목을 기술하는 곳이지요. ------------------------>
			                	<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
			                  답변 정보
			                </td>
							<td width="359" align="right" valign="bottom" class="text_s">
				            	<!------------------------- COUNT (PAGE) ------------------------------------>
						    	&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle">
				            	전체 자료 수 : <%= objRs.getRecordSize() %> 개&nbsp;&nbsp;
				            </td>
						</tr>
					</table>
				</td>
              </tr>
              <tr>
              
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
										<td height="22" width="19" align="center">NO</td>
										<td width="350" align="center">제출의견</td>
										<td width="100" align="center">작성자</td>
										<td width="80" align="center">공개</td>
										<td width="120" align="center">답변</td>
										<td width="90" align="center">답변일자</td>
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
						  if(objRs.getRecordSize() > 0) {
						  while(objRs.next()){
						   	 strAnsInfoID=(String)objRs.getObject("ANS_ID");
						 %>								
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
							<td>
								<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td height="22" width="19" align="center"><%=intRecordNumber%></td>
										<td width="350" class="td_lmagin"><a href="JavaScript:gotoAnsInfoView('<%=strAnsInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
										<td width="100" align="center"><%=(String)objRs.getObject("USER_NM")%></td>
										<td width="80" align="center"><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
										<td width="120" align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
										<td width="90" align="center"><%=StringUtil.getDate((String)objRs.getObject("ANS_DT"))%></td>
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
						%>
						<tr>
							<td height="35" align="center">제출된 답변이 없습니다</td>
						</tr>
						<%
							}
						%>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>      
					</table>
				</td>
				</tr>
              
               	<!-- 스페이스한칸 -->
               	<td>&nbsp;</td>
               	<!-- 스페이스한칸 -->
              </tr>
          </form>
          </table>
          </td>
        </tr>
        <tr>
        	<td height="35">&nbsp;</td>
        </tr>
    </table>
    <!--------------------------------------- 여기까지  MAIN WORK AREA 실제 코딩의 끝입니다. ----------------------------->      
    </td>
  </tr>
</table>
<%@ include file="../../../../common/Bottom.jsp" %>
</body>
</html>              
