<%@ page language="java"  contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>	
<%@ page import="java.net.*"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.util.BoardComm" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
	/*GET �Ķ����*/
	String strCurrentPage =  StringUtil.getNVLNULL(request.getParameter("strCurrentPage")); //���� ������
	String strBbrdID =  StringUtil.getNVLNULL(request.getParameter("bbrdid"));						//�Խ��� ���̵�
	String strDataID = StringUtil.getNVLNULL(request.getParameter("dataid"));							//�Խù� ���̵�
	
	if(strBbrdID == null || strBbrdID.equals("") || strBbrdID.equals(" ")){
		
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("�Խ��� ������ �˼� �����ϴ�.");
		
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
			
	}
	
	if(strDataID == null || strDataID.equals("") || strDataID.equals(" ")){
		
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("�Խù� ������ �˼� �����ϴ�.");
		
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
			
	}
	
	/*�ʱⰪ ���� */
	nads.dsdm.app.board.SLBoardDelegate objAuthBoard = new nads.dsdm.app.board.SLBoardDelegate();
	Hashtable objHshBbrdInfo = null;		//�Խ��� 
	Hashtable objHshMainInfo = null;		//�ֱ�
	Hashtable objHshBeforeInfo = null;		//������
	Hashtable objHshNextInfo = null;		//������
	ArrayList objAryTtopList = null;			//���ñ�
	ArrayList objAryFileList = null;				//�������� 
	String strGoToPage = URLEncoder.encode("/authinfo/AuthBoardContent.jsp", "UTF-8");
	String strDelGoToPage = URLEncoder.encode("/authinfo/AuthBoardList.jsp", "UTF-8");
	String strUpGoToPage = URLEncoder.encode("/authinfo/UpdateAuthBoard.jsp", "UTF-8");
	
	try{
		//1. �Խ��� ������ �����´�.
		objHshBbrdInfo = objAuthBoard.selectBbrdInfo(strBbrdID);
		
		//2. �ֱ�, ������, ������ ������ �����´�.
		Hashtable objHshDataInfo = objAuthBoard.selectBbrdBNInfo(strBbrdID, strDataID, "0");
		objHshMainInfo = (Hashtable)objHshDataInfo.get("MAIN_INFO");
		objHshBeforeInfo = (Hashtable)objHshDataInfo.get("BEFORE_INFO");
		objHshNextInfo = (Hashtable)objHshDataInfo.get("NEXT_INFO");
		
		//3. �ش� �Խù��� ���ñ� ����Ʈ�� �����´�.
		objAryTtopList = objAuthBoard.selectTtopDataList((String)objHshMainInfo.get("TTOP_BBRD_ID"));
		
		//4. ��ϵ� ������ �ִٸ� �������� ����Ʈ�� �����´�.
		if (((String)objHshMainInfo.get("APD_FILE_EXT")).equals("Y")) {
			objAryFileList = objAuthBoard.selectFileList(strDataID);
		}
		
	} catch (AppException objAppEx) {
	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
		
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
		
	}
	
	//�Խ��� ���� 
	String strBbrdKind = (String)objHshBbrdInfo.get("BBRD_KIND");
	int intBbrdFileCnt = Integer.valueOf((String)objHshBbrdInfo.get("APD_FILE_CNT")).intValue();
	String strBbrdAnsExt = (String)objHshBbrdInfo.get("ANS_EXT");
	String strBbrdOneExt = (String)objHshBbrdInfo.get("ONE_ANS_EXT");
		
	//�Խù� ���� 
	String strTitle = BoardComm.replaceTag2Text((String)objHshMainInfo.get("TITLE"));
	if (strTitle.equals("") || strTitle.equals(" " ) || strTitle == null){
		strTitle = "&nbsp;";
	}
	String strWriterNm = (String)objHshMainInfo.get("WRITER_NM");
	if (strWriterNm == null || strWriterNm.equals("") || strWriterNm.equals(" " )){
		strWriterNm = "&nbsp;";
	}
	String strCont = (String)objHshMainInfo.get("CONT");
	if (strCont == null || strCont.equals("") || strCont.equals(" " )){
		strCont = "&nbsp;";
	}
	String strEditorExt = (String)objHshMainInfo.get("HTML_USE_FLAG");
	if(strEditorExt.equals("N")) {
		strCont = BoardComm.replaceTag2Text(strCont); 
	}
	String strWriteTs = (String)objHshMainInfo.get("WRITE_TS");
	String strUpdTs = (String)objHshMainInfo.get("UPD_TS");
	if(!strUpdTs.equals("")){
		strWriteTs = strUpdTs;
	}
	strWriteTs = strWriteTs.substring(0, 4) + "-" + strWriteTs.substring(4, 6) + "-" 
						+ strWriteTs.substring(6, 8) + "&nbsp;&nbsp;" + strWriteTs.substring(8, 10) + ":" 
						+ strWriteTs.substring(10, 12) + ":" + strWriteTs.substring(12, 14);
	String strQryCnt = (String)objHshMainInfo.get("QRY_CNT");
	String strWriterID = (String)objHshMainInfo.get("WRITER_ID");
	//�����ڿ� ���� ������ ó�� 
	String strDelFlag = (String)objHshMainInfo.get("DEL_FLAG");
	if(strDelFlag.equals("A") || strDelFlag.equals("Y")){
		strTitle = "�ش���� ���� �Ǿ����ϴ�";
		//���뿡 ���� ������ ��Ÿ����.
		strCont = "�������� : " + (String)objHshMainInfo.get("DEL_RSN");
	}
	//���ٴ亯�� ���ؼ� �ʿ��� ��
	String strOneExt = (String)objHshMainInfo.get("ONE_ANS_EXT");
	//����� ���ؼ� �ʿ��� ��.
	String strTtopID = (String)objHshMainInfo.get("TTOP_BBRD_ID");
	String strLevel = (String)objHshMainInfo.get("DATA_LEVEL");
	String strOrder = (String)objHshMainInfo.get("DATA_ORDER");
	String strFileExt = (String)objHshMainInfo.get("APD_FILE_EXT");
	String strDataPwd = (String)objHshMainInfo.get("DATA_PWD");
%>

<html>
<head>
<title>++ ������ �߱޾ȳ�++</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="style.css" type="text/css">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/forum.js"></script>
<script language="javascript">

	function goToDelete(){
		
		var frm = document.frmContent;
		var msg = "�ش� ÷�������� ��� �����˴ϴ�.\n�Խù��� ���� �Ͻðڽ��ϱ�?";

	    if(confirm(msg)){
			frm.cmd.value = "DELETE";
			frm.oneext.value = "<%=strOneExt%>";
			frm.fileext.value = "<%=strFileExt%>";
			frm.strGoToPage.value = "<%=strDelGoToPage%>";
			frm.action = "/board/common/BoardProc.jsp?bbrdid=<%=strBbrdID%>&bbrdkind=<%=strBbrdKind%>";
			frm.submit();
	    }
	    else{
	        return false;
	    }

	}
	
	function goToAnswer(){
		
		var frm = document.frmContent;
		//���� �Խù��� ���� ������ ������.
		//delete ������ encType="multipart/form-data"�� ����ϹǷ� get ������� ����Ÿ�� �ѱ� 
		frm.action = "WriteAuthBoard.jsp?strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=strDataID%>&ttopid=<%=strTtopID%>&toplevel=<%=strLevel%>&toporder=<%=strOrder%>";

	}

</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="725" border="0" cellpadding="0" cellspacing="0" background="images/bg.gif">
  <tr>
    <td width="24">&nbsp;</td>
    <td width="677" align="center"> <br>
      <table width="636" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="10" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="13%" background="/image/board/bg_board_tit.gif"><span class="title">���ǰԽ���</span></td>
                <td width="28%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="30" align="left" class="soti_reqsubmit"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">
            <!-- ���ǰԽ��� ������ ���̺� ���� --------------------->
            <table width="636" border="0" cellspacing="0" cellpadding="0">
            <form name="frmContent" method="post" action="" encType="multipart/form-data">
		    <input type="hidden" name="cmd" value="">
		    <input type="hidden" name="strGoToPage" value="">
		    <input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
			<input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
			<input type="hidden" name="dataid" value="<%=strDataID%>">
			<input type="hidden" name="oneext" value="">
			<input type="hidden" name="fileext" value="">
              <tr> 
                <td width="120" height="2" class="td_board"></td>
                <td width="516" height="2" class="td_board"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ����</td>
                <td height="25" class="td_lmagin"><%=strTitle%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �����</td>
                <td height="25" class="td_lmagin"><%=strWriterNm%> (��ȸ : <%=strQryCnt%>)</td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �����</td>
                <td height="25" class="td_lmagin"><%=strWriteTs%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="35" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ����</td>
                <td height="100" valign="top" class="td_box"><%=strCont%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <% if (strDelFlag.equals("N") && intBbrdFileCnt != 0) {	//�Խ��� ������ ����÷�ΰ� 0���� �ƴ϶��....%>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ����</td>
                <td height="25" class="td_lmagin"> 
	            <%
	              if (objAryFileList != null) {
				    if (objAryFileList.size() != 0){
				    	for (int i = 0; i < objAryFileList.size(); i++) {
				    		Hashtable objHshFile = (Hashtable)objAryFileList.get(i);
				
							float fltSize =  (Integer.valueOf((String)objHshFile.get("FILE_SIZE")).floatValue())/1000;
							int intSize = 0;
							if(fltSize < 1){
								intSize = 1;
							} else {
								 intSize = Math.round(fltSize);
							}
					%>
	           	  <img src="/image/common/icon_file.gif" width="13" height="15" align="absmiddle"> 
	              <a href="/board/common/FileDownload.jsp?dataid=<%=strDataID%>&fileid=<%=(String)objHshFile.get("FILE_ID")%>"><%=(String)objHshFile.get("FILE_NAME")%></a> 
	              (<%=intSize%>KB) Download : <%=(String)objHshFile.get("DOWN_CNT")%><br>
	              <%
				    	}	//end for
				    } else {
				    	out.println("&nbsp;<br>");
				    }
				  }	//end if (null check)
				%>
                </td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <% } %>
              <!-- ������/������ ���� --------------------------------->
              <% if(objHshBeforeInfo.get("DATA_ID") != null){ %>
	            <tr> 
				  <td width="120" height="25" class="td_lmagin"><font color="792597"><img src="/image/forum/icon_boardDot.gif" width="3" height="5" align="absmiddle"></font> 
					  ������ :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				  <td width="516" height="25" class="td_lmagin">
				  	<a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage%>&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=objHshBeforeInfo.get("DATA_ID")%>">
				  	<%
			  		String strBTitle = BoardComm.replaceTag2Text((String)objHshBeforeInfo.get("TITLE"));
					String strBDelFlag = (String)objHshBeforeInfo.get("DEL_FLAG");
					if(strBDelFlag.equals("A") || strBDelFlag.equals("Y")){		//�����ڿ� ���� ���� 
						strBTitle = "�ش���� ���� �Ǿ����ϴ�";
					}
					out.println(strBTitle);
					%>
				  	</a>
				  </td>
				</tr>
				<%
	              }
	              
	              if(objHshNextInfo.get("DATA_ID") != null){
	            %>
				<tr> 
	              <td width="120" height="25" class="td_lmagin"><font color="792597"><img src="/image/forum/icon_boardDot.gif" width="3" height="5" align="absmiddle"></font> 
	              ������ :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	              <td width="560" height="25" class="td_lmagin">
	                <a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage%>&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=objHshNextInfo.get("DATA_ID")%>">
	                <%
	           		String strNTitle = BoardComm.replaceTag2Text((String)objHshNextInfo.get("TITLE"));
					String strNDelFlag = (String)objHshNextInfo.get("DEL_FLAG");
					if(strNDelFlag.equals("A") || strNDelFlag.equals("Y")){		//�����ڿ� ���� ���� 
						strNTitle = "�ش���� ���� �Ǿ����ϴ�";
					}
					out.println(strNTitle);
	                %>
	                </a>
	              </td>
	          	</tr>
	          	<% } %>
              <!-- ������/������ �� --------------------------------->
              <tr height="1"> 
                <td height="2" class="tbl-line"></td>
                <td height="2" class="tbl-line"></td>
              </tr>
              <tr>
                <td colspan="2" align="left" valign="top">
                <!-- ���ñ� ����Ʈ ���̺� ���� -------------------------------->
                 <% if (strBbrdAnsExt.equals("Y")) { 	//�Խ��� ��� ������ "Y"�� ��츸 ���ñ��� �����ش�.%>
                 <table width="636" border="0" cellspacing="0" cellpadding="0">
                  <tr> 
                  	<td height="20" align="left" valign="top">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td height="2" colspan="5" class="td_board"></td>
                  </tr>
                  <tr class="td_top"> 
                    <td width="396" height="22" align="center">����</td>
                    <td width="50" height="22" align="center">����</td>
                    <td width="70" height="22" align="center">�����</td>
                    <td width="70" height="22" align="center">�������</td>
                    <td width="50" align="center">��ȸ</td>
                  </tr>
                  <tr> 
                    <td height="1" colspan="5" class="td_board"></td>
                  </tr>
                  <%
                  if (objAryTtopList != null) {
					for (int i = 0; i < objAryTtopList.size(); i++) {
						Hashtable objHshTtopList = (Hashtable)objAryTtopList.get(i);
                  		
                  		String strTtopDataID = (String)objHshTtopList.get("DATA_ID");
                  		String strTtopTitle = BoardComm.replaceTag2Text((String)objHshTtopList.get("TITLE"));
                  		String strTtopDelFlag = (String)objHshTtopList.get("DEL_FLAG");
						if(strTtopDelFlag.equals("A") || strTtopDelFlag.equals("Y")){
							strTtopTitle = "�ش���� ���� �Ǿ����ϴ�";
						}
                  		if (strDataID.equals(strTtopDataID)){
                  			strTtopTitle = "<b>" + strTtopTitle + "</b>";
                  		}
                  		String strTtopFileExt = (String)objHshTtopList.get("APD_FILE_EXT");
						String strTtopFileExtImg = "&nbsp;";
						if(strTtopFileExt.equals("Y")){
							strTtopFileExtImg = "<img src='/image/common/icon_file.gif' width='13' height='15'>";
						}
                  		String strTtopWriteTs = (String)objHshTtopList.get("WRITE_TS");
                  		strTtopWriteTs = strTtopWriteTs.substring(0, 4) + "-" + strTtopWriteTs.substring(4, 6) + "-" 
													+ strTtopWriteTs.substring(6, 8);
						int intTtopLevel = Integer.valueOf((String)objHshTtopList.get("DATA_LEVEL")).intValue();
                  %>
                  <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
                    <td height="22" class="td_lmagin">
                        <%
							if(intTtopLevel > 0 ){
								String strTtopWid = "";
								
								for(int j=0; j < intTtopLevel ; j++){
									strTtopWid = strTtopWid + "&nbsp;&nbsp;&nbsp;";
								}
								out.print(strTtopWid + "<img src='/image/board/icon_reply.gif' border='0'>");		
							}
	                    %>
                    	<a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage%>&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=strTtopDataID%>"><%=strTtopTitle%></a>
                    </td>
                    <td height="22" align="center"><%=strTtopFileExtImg%></td>
                    <td height="22" align="center"><%=objHshTtopList.get("WRITER_NM")%></td>
                    <td height="22" align="center"><%=strTtopWriteTs%></td>
                    <td align="center"><%=objHshTtopList.get("QRY_CNT")%></td>
                  </tr>
                  <tr class="tbl-line"> 
                    <td height="1"></td>
                    <td height="1"></td>
                    <td height="1" align="left" class="td_lmagin"></td>
                    <td height="1" align="left" class="td_lmagin"></td>
                    <td align="left" class="td_lmagin"></td>
                  </tr>
                  <% 
                  		} 	//end for
                  	}	//end if
                  %>
                  <tr class="tbl-line"> 
                    <td height="1"></td>
                    <td height="1"></td>
                    <td height="1"></td>
                    <td height="1"></td>
                    <td></td>
                  </tr>
                </table>
                <% } //end if (���ñ� "Y")%>
                </td>
              </tr>
              <tr> 
		        <td height="40" align="left" colspan="2">
		          <%
					//��й�ȣ�� ���°�� ����, ���� ��ư�� �������� �ʴ´�.
					if(!strDataPwd.equals("") && !strDelFlag.equals("A")){
				  %>
		          <input type="image" src="/image/button/bt_modify.gif" width="43" height="20" onClick="openWin('ConfirmPwdPop.jsp?pwdcmd=CFM_UPDATE&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=strDataID%>&strGoToPage=<%=strUpGoToPage%>', '247', '175')"> 
		          <input type="image" src="/image/button/bt_delete.gif" width="43" height="20" onClick="openWin('ConfirmPwdPop.jsp?pwdcmd=CFM_DELETE&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=strDataID%>&strGoToPage=<%=strUpGoToPage%>', '247', '175')">
		          <%
		          	}
						//�Խ��� ��� ������ "Y"�� ��츸 ��� ��ư�� �����ش�.
						if (strBbrdAnsExt.equals("Y") && strDelFlag.equals("N")) { 
				  %>
				  <input type="image" src="/image/button/bt_reply.gif" width="43" height="20" onClick="goToAnswer()">
                  <% 
                		}
                  %>
		          <a href="AuthBoardList.jsp?strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>"><img src="/image/button/bt_list.gif" width="43" height="20" border="0"></a>
		        </td>
		      </tr>
		    </form>
            </table>
            <!-- ���ǰԽ��� ������ ���̺� �� --------------------->
          </td>
        </tr>
      </table>
      <br>
      <br>
    </td>
    <td width="24">&nbsp;</td>
  </tr>
  <tr>
    <td width="24">&nbsp;</td>
    <td><img src="images/copy.gif" width="677" height="29"></td>
    <td width="24">&nbsp;</td>
  </tr>
  <tr>
    <td width="24">&nbsp;</td>
    <td>&nbsp;</td>
    <td width="24">&nbsp;</td>
  </tr>
</table>
</body>
</html>