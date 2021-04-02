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
 /** 					�Ķ���� üũ Part 														  */
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
	String strCheckSearchGbnCode = null; //���������ڷ���ȸ�� �ߴ��� Ȯ��.


	boolean blnGovSubmtDataNoExist =  true;

	
	int intPageSize = 10 ; //  �����ټ��ִ� ������ �� 	
	int	intTotalRecordCount = 0;
	int	intCurrentPageNum = 0; // ���� ������ 
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
	strCheckSearchGbnCode  = request.getParameter("strCheckSearchGbnCode"); //���������ڷ���ȸ�� �ߴ��� Ȯ��.

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
	
		
	 	
	//���� ���� �ޱ�.
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
	// ���� ������ ��ȣ �ޱ�.
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
		
		intCurrentPageNum = objRs.getPageNumber();//������������ȣ		
		//System.out.println("intCurrentPageNum = " + intCurrentPageNum);
	    intTotalRecordCount = objRs.getTotalRecordCount();//��ü ��ȸ�� ���ڵ尹��
		//System.out.println("intTotalRecordCount = " + intTotalRecordCount);
	    intRecordNumber = objRs.getRecordSize(); //����� ���ڵ尳��
		//System.out.println("intRecordNumber = " + intRecordNumber);
	    intTotalPage = objRs.getTotalPageCount();//���������� 
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
		alert(" �����Ͻ� �䱸������ �����ϴ� \n�ϳ� �̻��� �䱸������ ������ �ּ���");  		
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
		alert("�Թ����սý��ۿ� ����� ����� �����ϼ���");
	}
  }
  
  function PdfFileOpen(strGovID,LPDF){
	  
      var http = "/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + strGovID + "&DOC=" + LPDF;

	  window.open(http,"PdfView",
		"resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );	
   }
   
    /** ��ü ���� ��ü ���� */
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
	  if(confirm("��������ý��ۿ��� ���ε� ��Ͽ��� �����Ͻðڽ��ϱ� ?")==true){
		document.GovSubmtList.method="post";
		document.GovSubmtList.action="/reqsubmit/80_bindreqlist/ReqBoxLegiSysConnectDeleteProc.jsp";
		document.GovSubmtList.strBindingSortField.value=sortField;
	  	document.GovSubmtList.strBindingSortMtd.value=sortMethod;
		document.GovSubmtList.strBindingPageNum.value=intCurrentPageNum;
		document.GovSubmtList.submit();
	  }
	}else{
		alert("������ ����� �����ϼ���");
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
    <!------- 2004-06-02 ������ �������� ���� ����� �κ� ���� ------->
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
<!------- 2004-06-02 ������ �������� ���� ����� �κ� �� ------->	
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
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title">��������ý��ۿ��� �ǿ��䱸�亯 ���ε� �ڷ���</span> 
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="19%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
							<!--<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                         		>  > </B>
                         	-->
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- ���� �������� ���� ���� ��� ------------------------>
                		 ��������ý��� ���� �ǿ��䱸�亯���� ���ε� �ڷ� ����Դϴ�.
                </td>
              </tr>
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr> 
                <td height="30" class="soti_reqsubmit">
                	<!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
                	<table border="0" cellpadding="0" cellspacing="0" width="759">

<form name="GovSubmtList" method="get" action="<%=request.getRequestURI()%>">
                		<tr>
                			<td width="400">
								<table border="0" cellspacing="0" cellpadding="0">
									<tr>
                						<td valign="top">
											<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle">
											��������ý��ۿ��� ���ε� �ڷ���
										 </td>
                					</tr>
                				</table>
							</td>
				            <td width="359" align="right" valign="bottom">
				            	<!------------------------- COUNT (PAGE) ------------------------------------>
				            	��ü �ڷ� �� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage%> Page)								
				            </td>
				       </tr>
				   </table>
                </td>
              </tr>
              <tr> 
                <td align="left" valign="top" class="soti_reqsubmit">
                <!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� ��~~~�� ------------------------->
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
            	          	<td width="105" height="22">�䱸���</td>
		    	          	<td width="105" height="22">������</td>
							<td width="279"height="22"><%=SortingUtil.getSortLink("changeSortQuery","DATA_NM",strBindingSortField,strBindingSortMtd,"�ڷ��")%>
							</td>
						    <td width="90" height="22"><%=SortingUtil.getSortLink("changeSortQuery","REGR_ID",strBindingSortField,strBindingSortMtd,"�����ID")%></td>
							<td width="30" height="22">����</td>							
							<td width="65" height="22"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strBindingSortField,strBindingSortMtd,"�����")%>
							<td width="95" height="22"><%=SortingUtil.getSortLink("changeSortQuery","AUDIT_SYS_REL_FLAG",strBindingSortField,strBindingSortMtd,"�����ý��ۿ���")%>
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
										  strConnect = "���";
								%>
  	 	                			<td align="center"><input type="checkbox" Disabled></td>
								<%
									}else{
										  strConnect = "�̵��";
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
										if(strPDFFilePath == "DB�����" || strPDFFilePath.equals("DB�����")){
											out.println("�����");								
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
								//System.out.println("\n ����� ���ڵ尳�� 0 ���� �۴�.");
						%>
						<tr>
							<td colspan="7" height="40" align="center">��ϵ� �����ý��ۿ����ڷᰡ �����ϴ�.</td>
						</tr>
						<td align="center"><input type="hidden" name="LegiConn" value =""></td>
						<%
							}
						} else { //end blnGovSubmtDataNoExist = true
								//System.out.println("\n DB���� �޾ƿ� HASHTABEL�� NULL �̴�.");
						%>
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
  	 	                	<tr height="22">
							<td colspan="8" height="40" align="center">��ϵ� �����ý��ۿ����ڷᰡ �����ϴ�.</td>
							</tr>            	        
    	                </tr> 
						<%
						} //blnBindFileSessionExist
						%>
    	           </table>

				<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� �� ------------------------->
               </td>
              </tr>
			<%
			//System.out.println("blnGovSubmtDataNoExist = " +blnGovSubmtDataNoExist);
				if(intRecordNumber > 0){
			%>
			 <tr> 
                <td height="35" align="Center">
                	<!-----------------------------------------  ����¡ �׺���̼� ---------------------------------------->
                	<table>
						<tr>
							 <td width="459" align="Center">   	
			                <!-----------------------------------------  ����¡ �׺���̼� ---------------------------------------->
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
		  

			   <input type="hidden" name="strGovSubmtDataId" value="">  <!--���������ڷ� id --> 			   
               <input type="hidden" name="strBindingSortField" value="<%=strBindingSortField%>">  <!--���� �ʵ� -->
               <input type="hidden" name="strBindingSortMtd" value="<%=strBindingSortMtd%>">  
			   <!--��������  ��������,�������� --> 			   
               <input type="hidden" name="strBindingPageNum" value="<%=strBindingPageNum%>">  <!-- �������� --> 
			   <input type="hidden" name="strBindingQryField" value="<%=strBindingQryField%>"> <!--�˻��ʵ� 000 �̸� ��ü -->			   
			   <input type="hidden" name="strBindingQryTerm" value="<%=strBindingQryTerm%>"> <!--�˻��� -->
   			   <input type="hidden" name="strReqOrgNm" value=""> <!--�䱸��� -->
   			   <input type="hidden" name="strSubmtOrgNm" value=""> <!--������ -->
			    <input type="hidden" name="strCheckSearchGbnCode" value=""> <!--��ȸ��ư ���ý� -->
               
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