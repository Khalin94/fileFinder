<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.binder.bindDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null; 
%>
<%@ include file="../common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/

    StringUtil objDate = new StringUtil();	
	ArrayList objAllBinderArray = null;
	Hashtable objBindHash = null;
	ResultSetHelper objRs = null;	
	UserInfoDelegate objUser = null;
	bindDelegate objBinder = null;

	String strBindingSortField = null;
	String strBindingSortMtd = null;
	String strBindingPageNum = null;


	String strPdfFilePath = null;
	String	strBindingQryField = null;
	String	strBindingQryTerm = null;	
	String strCheckSearchGbnCode = null; //정부제출자료조회를 했는지 확인.


	boolean blnGovSubmtDataNoExist =  true;

	
	int intPageSize = 10 ; //  보여줄수있는 페이지 수 	
	int	intTotalRecordCount = 0;
	int	intCurrentPageNum = 0; // 현재 페이지 
	int	intTotalPage = 0;
	int	intRecordNumber = 0;
	int intStartPage = 0;
	int intEndPage = 0;
	int intRecordNumberCount = 0;
	
	String strGovConnectId = null;
	String strReqBoxID = null;
	String strReqDataNm = null;
	String strRegerID = null;
	String strRegDT = null;
	String strPDFFilePath = null;
	String strConnect = null ;
	String	strSubmtOrgNm = null ;
	String	strReqOrgNm = null ;
	
	
	String strQryFieldValue =StringUtil.toHan(request.getParameter("strBindingQryField"));		
	String strQryTermValue = request.getParameter("strBindingQryTerm");
	strCheckSearchGbnCode  = request.getParameter("strCheckSearchGbnCode"); //정부제출자료조회를 했는지 확인.

	System.out.println("[ReqBoxLegiSysConnectList.jsp] strQryFieldValue = " + strQryFieldValue);
	if(strQryFieldValue == null || strQryFieldValue == "" ||strQryFieldValue.equals("")){
		strBindingQryField = "000";
	}else{
		strBindingQryField = strQryFieldValue;		
		if(strCheckSearchGbnCode == null || strCheckSearchGbnCode == "" || strCheckSearchGbnCode.equals("")){					
			System.out.println("[ReqBoxLegiSysConnectList.jsp] strBindingQryField = " + strBindingQryField);
		}
	}

	
	

	System.out.println("[ReqBoxLegiSysConnectList.jsp] strBindingQryField = " + strBindingQryField);


	if( strQryTermValue == null || strQryTermValue.equals("")){
		strBindingQryTerm = "";
	}else{
		strQryTermValue = StringUtil.toMulti(strQryTermValue);
		StringUtil.isAssigned(strQryTermValue);		 	
		strBindingQryTerm = strQryTermValue;
	}
	//System.out.println("[ReqBoxLegiSysConnectList.jsp] strBindingQryTerm = " + strBindingQryTerm);
	
	objUser = new UserInfoDelegate(request);
	String strUserNm  =	objUser.getUserName();
	//System.out.println("[ReqBoxLegiSysConnectList.jsp] strUserNm =" + strUserNm);	
	
		
	 	
	//정렬 정보 받기.
	strBindingSortField = StringUtil.toHan(request.getParameter("strBindingSortField"));
	if(strBindingSortField == null || strBindingSortField.equals("")){
		strBindingSortField = "REG_DT";
	}
	//strBindingSortField = objParams.getParamValue("strBindingSortField");
	//System.out.println("[ReqBoxLegiSysConnectList.jsp] strBindingSortField = " + strBindingSortField);
 	strBindingSortMtd= request.getParameter("strBindingSortMtd");
 	if(strBindingSortMtd == null || strBindingSortMtd.equals("")){
	 	strBindingSortMtd = "DESC";
 	}
 		
 	
	//System.out.println("[ReqBoxLegiSysConnectList.jsp] strBindingSortMtd = " + strBindingSortMtd);
	// 정보 페이지 번호 받기.
	strBindingPageNum = request.getParameter("strBindingPageNum");	
	if(strBindingPageNum == null ||strBindingPageNum.equals("")){
		strBindingPageNum = "1";
	}
	//System.out.println("[ReqBoxLegiSysConnectList.jsp] strBindingPageNum = " + strBindingPageNum);	
	Integer objIntD = new Integer(strBindingPageNum);
	intCurrentPageNum = objIntD.intValue();
	//System.out.println("[ReqBoxLegiSysConnectList.jsp] intCurrentPageNum = " + intCurrentPageNum);
		
    objBinder = new bindDelegate();
    	    
    intRecordNumber= (intCurrentPageNum -1) * intPageSize +1;
	intStartPage = intRecordNumber;
	intEndPage = intCurrentPageNum*10;
		
	//System.out.println("intStartPage =" + intStartPage + "\nintEndPage =" + intEndPage);
		
	objBindHash = objBinder.GovConnectBindingList( strBindingSortField, strBindingSortMtd,  intCurrentPageNum, intPageSize);	
	//System.out.println("size =" +	objBindHash.size());
	
	/*for (java.util.Enumeration enum=objBindHash.keys(); enum.hasMoreElements();){
		System.out.println("Key:" + (String)enum.nextElement());
	}*/
	String strCountNum = (String)objBindHash.get("TotalPage");
	//System.out.println("strCountNum = " + strCountNum);
	
	
	if(objBindHash != null ){
		blnGovSubmtDataNoExist = false;
	
		objRs =new ResultSetHelper(objBindHash);
		
		intCurrentPageNum = objRs.getPageNumber();//현재페이지번호		
		//System.out.println("intCurrentPageNum = " + intCurrentPageNum);
	    intTotalRecordCount = objRs.getTotalRecordCount();//전체 조회된 레코드갯수
		//System.out.println("intTotalRecordCount = " + intTotalRecordCount);
	    intRecordNumber = objRs.getRecordSize(); //출력할 레코드개수
		//System.out.println("intRecordNumber = " + intRecordNumber);
	    intTotalPage = objRs.getTotalPageCount();//페이지개수 
		//System.out.println("intTotalPage = " + intTotalPage);
 	}

   // strPageSize = Integer.toString(intRecordNumber);

%>
<script language="javascript">

  
  function changeSortQuery(sortField,sortMethod){
  	GovSubmtList.strBindingSortField.value=sortField;
  	GovSubmtList.strBindingSortMtd.value=sortMethod;
  	GovSubmtList.submit();
  }
  
  function goPage(strPage){
  	GovSubmtList.strBindingPageNum.value=strPage;
  	GovSubmtList.submit();
  }
  
  function hashCheckedReqInfoIDs(formName){	
	var blnFlag=false;  	
	if(formName.ReqInfoIDs.length==undefined){  	  
		if(formName.ReqInfoIDs.checked==true){  	  	
			blnFlag=true;  	  
		}  	
	}else{  	  
		var intLen=formName.ReqInfoIDs.length;  	  
		for(var i=0;i<intLen;i++){  	    
			if(formName.ReqInfoIDs[i].checked==true){  	      
				blnFlag=true;break;  	    
			}  	  
		}  	
	}  	
	if(blnFlag==false){  		
		alert(" 선택하신 요구정보가 없습니다 \n하나 이상의 요구정보를 선택해 주세요");  		
		return false;  	
	}  	
	return true;  	  
}    

  function gotoGovSubDataBoxLegiConnect(formName,submtOrg,reqOrg){
	var blnCheck = false;

	if(formName.LegiConn.length==undefined){
		if(formName.LegiConn.checked==true){  	  	
			blnCheck=true;  	  
		}  	
	}else{  
		var intLen=formName.LegiConn.length;  	  
		for(var i=0;i<intLen;i++){  	    
			if(formName.LegiConn[i].checked==true){  	      
				blnCheck=true;break;  	    
			}  	  
		}  	
	}  
	if(blnCheck){
		var varAction = formName.action;
		formName.action="/reqsubmit/80_bindreqlist/ReqBoxLegiSysConnect.jsp";
		formName.strSubmtOrgNm.value =submtOrg;
		formName.strReqOrgNm.value =reqOrg;
		formName.submit();
		formName.action = varAction;
	}else{
		alert("입법통합시스템에 등록할 목록을 선택하세요");
	}
  }
  
  function PdfFileOpen(strGovID,LPDF){
	  
      var http = "/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + strGovID + "&DOC=" + LPDF;

	  window.open(http,"PdfView",
		"resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );	
   }
   
    /** 전체 선택 전체 해제 */
  var blnCheckBoxFlag=false;
  function checkAllOrNot(formName){
   var i, chked=0, k=0;
   	  blnCheckBoxFlag=!blnCheckBoxFlag;
	  for(i=0;i<formName.length;i++){
	   if(formName[i].type=='checkbox'){
		//if(document.formName[i].checked){formName[i].checked=false;} else{formName[i].checked=true;}
		  formName[i].checked=blnCheckBoxFlag;
		  formName.checkAll.checked=blnCheckBoxFlag;
	   }
	}
	return true;
  }//end func

 function gotoHeadQuery(selCode,formName){
	 var varAction = formName.action;
		// alert(selCode);		
		formName.strCheckSearchGbnCode.value = "001";
		formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataBoxList.jsp";
		formName.submit();
		formName.action = varAction;
 }
 
  function gotoDelete(sortField,sortMethod,intCurrentPageNum,intCount){		
	  //disabled
		var blnCheck = false;
//		var intCount = document.GovSubmtList.LegiConn.length;
		var formName = document.GovSubmtList ;

	if(formName.LegiConn.length==undefined){ 			
		if(formName.LegiConn.checked==true){  	  	
			blnCheck=true;  	  
		}  	
	}else{  
		var intLen=formName.LegiConn.length;  	  
		for(var i=0;i<intLen;i++){  	    
			if(formName.LegiConn[i].checked==true){  	      
				blnCheck=true;break;  	    
			}  	  
		}  	
	}  

/*		if(intCount == null || intCount < 2){
			if(document.GovSubmtList.LegiConn.checked == 1){
				blnCheck = true;
			}else{
				blnCheck = false;
			}
		}else if(intCount == 1){
			document.GovSubmtList.LegiConn.checked == 1	;		
		}else{
			for(var i = 0 ; i < intCount ; i++){			
				if(document.GovSubmtList.LegiConn[i].checked == 1){
					blnCheck = true;
					break;
				}else{
					blnCheck = false;
				}
			}
		}
*/
	if(blnCheck){
	  if(confirm("국정감사시스템연계 바인딩 목록에서 삭제하시겠습니까 ?")==true){
		document.GovSubmtList.method="post";
		document.GovSubmtList.action="/reqsubmit/80_bindreqlist/ReqBoxLegiSysConnectDeleteProc.jsp";
		document.GovSubmtList.strBindingSortField.value=sortField;
	  	document.GovSubmtList.strBindingSortMtd.value=sortMethod;
		document.GovSubmtList.strBindingPageNum.value=intCurrentPageNum;
		document.GovSubmtList.submit();
	  }
	}else{
		alert("삭제할 목록을 선택하세요");
	}

  }

</script>
<link href="/css/global.css"  rel="stylesheet" type="text/css" />
<link href="/css/System.css" rel="stylesheet" type="text/css">
<html>
<head>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/reqsubmit/common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="/reqsubmit/common/MenuLeftReqsubmit.jsp" %>
	</td>
    <!------- 2004-06-02 디자인 수정으로 인해 변경된 부분 시작 ------->
<td width="100%">
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
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
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="65%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- 타이틀을 입력해 주세요 ------------------------>
                      		<span class="title">국정감사시스템연계 의원요구답변 바인딩 자료함</span> 
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="19%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- 현재 위치 정보를 기술한답니다. ------------------------>
							<!--<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                         		>  > </B>
                         	-->
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- 현재 페이지에 대한 설명 기술 ------------------------>
                		 국정감사시스템 연계 의원요구답변파일 바인딩 자료 목록입니다.
                </td>
              </tr>
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr> 
                <td height="30" class="soti_reqsubmit">
                	<!-------------------- TAB 에 해당하는 제목을 기술하는 곳이지요. ------------------------>
                	<table border="0" cellpadding="0" cellspacing="0" width="759">

<form name="GovSubmtList" method="get" action="<%=request.getRequestURI()%>">
                		<tr>
                			<td width="400">
								<table border="0" cellspacing="0" cellpadding="0">
									<tr>
                						<td valign="top">
											<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle">
											국정감사시스템연계 바인딩 자료함
										 </td>
                					</tr>
                				</table>
							</td>
				            <td width="359" align="right" valign="bottom">
				            	<!------------------------- COUNT (PAGE) ------------------------------------>
				            	전체 자료 수 : <%=intTotalRecordCount%>개 (<%=intCurrentPageNum%> / <%=intTotalPage%> Page)								
				            </td>
				       </tr>
				   </table>
                </td>
              </tr>
              <tr> 
                <td align="left" valign="top" class="soti_reqsubmit">
                <!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 시~~~작 ------------------------->
<!--<form name="GovSubmtList" method="get" action="<%=request.getRequestURI()%>">-->
					<table width="759" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td height="2" colspan="9" class="td_reqsubmit"></td>
	                    </tr>	                    
    	                <tr align="center" class="td_top"> 
        	            	<td width="10" height="22">
        	            	<input id="check"  type="checkbox" name="checkAll" onClick="checkAllOrNot(document.GovSubmtList);">
        	            	</td>
            	          	<td width="10" height="22">NO</td> 
            	          	<td width="105" height="22">요구기관</td>
		    	          	<td width="105" height="22">제출기관</td>
							<td width="279"height="22"><%=SortingUtil.getSortLink("changeSortQuery","DATA_NM",strBindingSortField,strBindingSortMtd,"자료명")%>
							</td>
						    <td width="90" height="22"><%=SortingUtil.getSortLink("changeSortQuery","REGR_ID",strBindingSortField,strBindingSortMtd,"등록자ID")%></td>
							<td width="30" height="22">파일</td>							
							<td width="65" height="22"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strBindingSortField,strBindingSortMtd,"등록일")%>
							<td width="95" height="22"><%=SortingUtil.getSortLink("changeSortQuery","AUDIT_SYS_REL_FLAG",strBindingSortField,strBindingSortMtd,"국감시스템연계")%>
							</td>
            	        </tr>
                	    <tr> 
                    	  	<td height="1" colspan="9" class="td_reqsubmit"></td>
                    	</tr>
                    <%
          		
								
 						if(!blnGovSubmtDataNoExist){	
							
							intRecordNumberCount = intTotalRecordCount - ((intCurrentPageNum -1) * intPageSize);	
							
							
							 if(intRecordNumber > 0){								
								while(objRs.next()){								
								 									 	
 								    strGovConnectId  = (String)objRs.getObject("AUDIT_SYS_REL_DATA_ID");
									strReqBoxID = (String)objRs.getObject("REQ_BOX_ID");
  								    strReqDataNm = (String)objRs.getObject("DATA_NM"); 	
  								    strRegerID = (String)objRs.getObject("REGR_ID"); 	
  								   	strRegDT = (String)objRs.getObject("REG_DT");      
										 strRegDT = StringUtil.getDate(strRegDT);
									strPDFFilePath	= (String)objRs.getObject("PDF_FILE_PATH");
									strConnect  = (String)objRs.getObject("AUDIT_SYS_REL_FLAG");
									
									strSubmtOrgNm  = (String)objRs.getObject("SUBMT_ORGAN_NM");
									strReqOrgNm  = (String)objRs.getObject("REQ_ORGAN_NM");
						 %>			
						 
	                    <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
  	 	                	
  	 	                	<tr height="22">
								<%
									if( strConnect == "Y" || strConnect.equals("Y")){
										  strConnect = "등록";
								%>
  	 	                			<td align="center"><input type="checkbox" Disabled></td>
								<%
									}else{
										  strConnect = "미등록";
								%>
									<td align="center"><input type="checkbox" name="LegiConn" value ="<%=strGovConnectId%>"></td>
								<%
									}
														
								%>							
	
									<td align="center"><%=intRecordNumberCount%></td>
									<td align="center"><%=strReqOrgNm%></td>
									<td align="center"><%=strSubmtOrgNm%></td>
									<td align="center"><%=strReqDataNm%></td>
									<td align="center"><%=strRegerID%></td>
									<td align="center">
									<%
										if(strPDFFilePath == "DB등록중" || strPDFFilePath.equals("DB등록중")){
											out.println("등록중");								
										}else{
									%>
									<a href="javascript:PdfFileOpen('<%=strGovConnectId%>','LPDF');"><img src="/image/common/icon_pdf.gif" border="0"></a>
									<%
										}
									%>
									</td>
									<td align="center"><%=strRegDT%></td>				
									<td align="center"><%=strConnect%></td>
								
							</tr>            	        
    	                </tr>
    	                <tr class="tbl-line"> 
                      		<td height="1" colspan="9"></td>
                    	</tr>
                    	<%
	                    		 intRecordNumberCount --; 
								 }//end While	
							} else { // end intRecordNumber
								//System.out.println("\n 출력할 레코드개수 0 보다 작다.");
						%>
						<tr>
							<td colspan="7" height="40" align="center">등록된 국감시스템연계자료가 없습니다.</td>
						</tr>
						<td align="center"><input type="hidden" name="LegiConn" value =""></td>
						<%
							}
						} else { //end blnGovSubmtDataNoExist = true
								//System.out.println("\n DB에서 받아온 HASHTABEL이 NULL 이다.");
						%>
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
  	 	                	<tr height="22">
							<td colspan="8" height="40" align="center">등록된 국감시스템연계자료가 없습니다.</td>
							</tr>            	        
    	                </tr> 
						<%
						} //blnBindFileSessionExist
						%>
    	           </table>

				<!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 끝 ------------------------->
               </td>
              </tr>
			<%
			//System.out.println("blnGovSubmtDataNoExist = " +blnGovSubmtDataNoExist);
				if(intRecordNumber > 0){
			%>
			 <tr> 
                <td height="35" align="Center">
                	<!-----------------------------------------  페이징 네비게이션 ---------------------------------------->
                	<table>
						<tr>
							 <td width="459" align="Center">   	
			                <!-----------------------------------------  페이징 네비게이션 ---------------------------------------->
			                	<%= PageCount.getLinkedString(
										new Integer(intTotalRecordCount).toString(),
										new Integer(intCurrentPageNum).toString(),
										new Integer(intPageSize).toString())
								%>
			                </td>
						</tr>
					</table>
                </td>
              </tr>
			<%
			   }
			%>
			  <tr height="3">
              	<td height="3" align="left" valign="top" background="/image/common/line_table.gif"></td>
              </tr> 

              <tr> 
                <td height="35" align="left">
                	<table border="0" cellpadding="0" cellspacing="0">
                		<tr>
                			<td width="300">
							<!--<img src="/image/button/bt_linkGukgam.gif" height="20" border="0" onClick="gotoGovSubDataBoxLegiConnect(document.GovSubmtList,'<%//=strReqOrgNm%>','<%//=strSubmtOrgNm%>')" style="cursor:hand">-->											                	
							<!--<img src="/image/button/bt_delete.gif"  height="20" border="0" onClick="gotoDelete('<%//=strBindingSortField%>','<%//=strBindingSortMtd%>','<%//=intCurrentPageNum%>','<%//=intRecordNumberCount%>')" style="cursor:hand"> -->
			                </td>		                							
			            </tr>
			         </table>
                	
                </td>
              </tr>    
		  

			   <input type="hidden" name="strGovSubmtDataId" value="">  <!--정부제출자료 id --> 			   
               <input type="hidden" name="strBindingSortField" value="<%=strBindingSortField%>">  <!--정렬 필드 -->
               <input type="hidden" name="strBindingSortMtd" value="<%=strBindingSortMtd%>">  
			   <!--정렬차순  오름차순,내림차순 --> 			   
               <input type="hidden" name="strBindingPageNum" value="<%=strBindingPageNum%>">  <!-- 페이지수 --> 
			   <input type="hidden" name="strBindingQryField" value="<%=strBindingQryField%>"> <!--검색필드 000 이면 전체 -->			   
			   <input type="hidden" name="strBindingQryTerm" value="<%=strBindingQryTerm%>"> <!--검색어 -->
   			   <input type="hidden" name="strReqOrgNm" value=""> <!--요구기관 -->
   			   <input type="hidden" name="strSubmtOrgNm" value=""> <!--제출기관 -->
			    <input type="hidden" name="strCheckSearchGbnCode" value=""> <!--조회버튼 선택시 -->
               
<!--</form>-->
</form>
            </table>
            </td>
        </tr>
      </table>

	  </td>
  </tr>
</table>
<%@ include file="/common/Bottom.jsp" %>
</body>
</html>