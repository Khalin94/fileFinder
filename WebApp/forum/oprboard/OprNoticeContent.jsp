<%@ page language="java"  contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.Math" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.util.BoardComm" %>

<%
	//���� �������� ������ ��.
	String strUserID = "tester1"; 																				//�α��� ID
	String strUserName = "ȫ�浿"; 																		//�α��� Name
	
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //���� ������
	String strBbrdID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));			 //�Խ��� ���̵�
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));			 //�Խù� ���̵�

	nads.dsdm.app.board.SLBoardDelegate objOprBoard = new nads.dsdm.app.board.SLBoardDelegate();
	Hashtable objHshBbrdInfo = null;			//�Խ��� 
	Hashtable objHshMainInfo = null;			//�ֱ�
	Hashtable objHshBeforeInfo = null;			//������
	Hashtable objHshNextInfo = null;			//������
	ArrayList objAryTtopList = null;				//���ñ�
	ArrayList objAryFileList = null;					//�������� 
	
	try{
		//1. �Խ��� ������ �����´�.
		objHshBbrdInfo = objOprBoard.selectBbrdInfo(strBbrdID);
		
		//2. �ֱ�, ������, ������ ������ �����´�.
		Hashtable objHshDataInfo = objOprBoard.selectBbrdBNInfo(strBbrdID, strDataID, "1");
		objHshMainInfo = (Hashtable)objHshDataInfo.get("MAIN_INFO");
		objHshBeforeInfo = (Hashtable)objHshDataInfo.get("BEFORE_INFO");
		objHshNextInfo = (Hashtable)objHshDataInfo.get("NEXT_INFO");
		
		//3. �ش� �Խù��� ���ñ� ����Ʈ�� �����´�.
		objAryTtopList = objOprBoard.selectTtopDataList((String)objHshMainInfo.get("TTOP_BBRD_ID"));
		
		//4. ��ϵ� ������ �ִٸ� �������� ����Ʈ�� �����´�.
		if (((String)objHshMainInfo.get("APD_FILE_EXT")).equals("Y")) {
			objAryFileList = objOprBoard.selectFileList(strDataID);
		}
	
	} catch (AppException objAppEx) {
	
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
		out.println(objAppEx.getStrErrCode() + "<br>");
		out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.<br>");
		return;
		
	}
	
	//�Խ��� ���� 
	int intBbrdFileCnt = Integer.valueOf((String)objHshBbrdInfo.get("APD_FILE_CNT")).intValue();
	String strBbrdNm = (String)objHshBbrdInfo.get("BBRD_NM");
	int intBbrdLength = strBbrdNm.length() * 3  - 2;
	int intBbrdLength2 = 0;
	if(intBbrdLength < 100) {
		intBbrdLength2 = 100 - intBbrdLength;
	}
	String strBbrdAnsExt = (String)objHshBbrdInfo.get("ANS_EXT");
	String strBbrdOneExt = (String)objHshBbrdInfo.get("ONE_ANS_EXT");
	
	//�Խù� ���� 
	String strTitle = (String)objHshMainInfo.get("TITLE");
	if (strTitle.equals("") || strTitle.equals(" " ) || strTitle == null){
		strTitle = "&nbsp;";
	}
	String strUserNm = (String)objHshMainInfo.get("USER_NM");
	if (strUserNm.equals("") || strUserNm.equals(" " ) || strUserNm == null){
		strUserNm = "&nbsp;";
	}
	String strCont = (String)objHshMainInfo.get("CONT");
	if (strCont.equals("") || strCont.equals(" " ) || strCont == null){
		strCont = "&nbsp;";
	}
	String strWriteTs = (String)objHshMainInfo.get("WRITE_TS");
	String strUpdTs = (String)objHshMainInfo.get("UPD_TS");
	if(!strUpdTs.equals("")){
		strWriteTs = strUpdTs;
	}
	strWriteTs = strWriteTs.substring(0, 4) + "-" + strWriteTs.substring(4, 6) + "-" + strWriteTs.substring(6, 8);
	//�����ڿ� ���� ������ ó�� 
	String strDelFlag = (String)objHshMainInfo.get("DEL_FLAG");
	if(strDelFlag.equals("A") || strDelFlag.equals("Y")){
		strTitle = "�ش���� ���� �Ǿ����ϴ�";
		//���뿡 ���� ������ ��Ÿ����.
		strCont = "�������� : " + (String)objHshMainInfo.get("DEL_RSN");
	}
	String strQryCnt = (String)objHshMainInfo.get("QRY_CNT");
	String strFilePath= (String)objHshMainInfo.get("FILE_PATH");
	//���ٴ亯�� ���ؼ� �ʿ��� ��
	String strOneExt = (String)objHshMainInfo.get("ONE_ANS_EXT");
	
	//out.println("DATA_ID : " + strDataID + "<br>");	
	//out.println("strFileExt : " + strFileExt + "<br>");	
	//out.println("File Size : " + objAryFileList.size() + "<br>");
%>

<html>
<head>
<title>��ȸ ����Ȱ�� �������� �������� �ý���</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/forum.js"></script>
<script language="javascript">
	function goToOneSave(){
		var frm = document.frmOneAns;
		
		if (frm.oneword != null && frm.oneword != "" ){
			if (frm.oneword.value == "" || frm.oneword.value == null){
				alert("���ٴ�� ������ �Է��� �ּ���.");
				frm.oneword.focus();
				return false;
			}
		}
		
		//�ѱ�, ���� �����Ͽ� ���ڿ� ���̸� üũ�Ѵ�.
        if(checkStrLen(frm.oneword, 100, "���� ���") == false){
            return false;
        }
        
        frm.submit();
	}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/forum/common/MenuTopForumPop2.jsp" %>
<table width="800" height="450" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top"> 
    <td width="149" background="/image/forum/bg_forumLeft.gif"> 
      <%@ include file="/forum/common/MenuLeftForumPop2.jsp" %>
    </td>
    <td align="center"><table width="589" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="21" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="<%=intBbrdLength%>%" background="/image/forum/bg_forumpop_tit.gif"><span class="title"><%=strBbrdNm%></span></td>
                <td width="<%=intBbrdLength2%>%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="30" align="left" class="text_s"><%=objHshBbrdInfo.get("DSC")%></td>
        </tr>
        <tr> 
          <td height="5" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">
          	<!-- ��� �������� �󼼺��� ���̺� ���� ---------------->
          	<table width="100%" border="0" cellspacing="0" cellpadding="0">
          	<form name="frmContent" method="post" encType="multipart/form-data" action="">
			<input type="hidden" name="cmd" value="">
			<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
			<input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
			<input type="hidden" name="dataid" value="<%=strDataID%>">
			<input type="hidden" name="fileext" value="">
              <tr> 
                <td width="95" height="2" class="td_forumpop"></td>
                <td width="494" height="2" class="td_forumpop"></td>
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
                <td height="25" class="td_lmagin"><%=strUserNm%> (��ȸ : <%=strQryCnt%>)</td>
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
                <td height="34" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ����</td>
                <td height="45" valign="top" class="td_box"><%=strCont%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <% if (intBbrdFileCnt != 0) {	//�Խ��� ������ ����÷�ΰ� 0���� �ƴ϶��....%>
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
                  <a href="/forum/common/FileDownload.jsp?dataid=<%=strDataID%>&filepath=<%=strFilePath%>&fileid=<%=(String)objHshFile.get("FILE_ID")%>"><%=(String)objHshFile.get("FILE_NAME")%></a> 
                  (<%=intSize%>KB) download : <%=(String)objHshFile.get("DOWN_CNT")%><br>
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
                <td height="25" class="td_lmagin"><font color="792597"><img src="/image/forum/icon_boardDot.gif" width="3" height="5" align="absmiddle"></font> 
                  ������ :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td height="25" class="td_lmagin"><a href="OprList2Content.jsp?strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=objHshBeforeInfo.get("DATA_ID")%>">
                <%
		  		String strBTitle = BoardComm.replaceTag2Text((String)objHshBeforeInfo.get("TITLE"));
				String strBDelFlag = (String)objHshBeforeInfo.get("DEL_FLAG");
				if(strBDelFlag.equals("A") || strBDelFlag.equals("Y")){	//������ �Ǵ� ��ڿ� ���� ���� 
					strBTitle = "�ش���� ���� �Ǿ����ϴ�";
				}
				out.println(strBTitle);
				%>
                </a></td>
              </tr>
              <%
              }
              
              if(objHshNextInfo.get("DATA_ID") != null){
              %>
              <tr> 
                <td height="25" class="td_lmagin"><font color="792597"><img src="/image/forum/icon_boardDot.gif" width="3" height="5" align="absmiddle"></font> 
                  ������ :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td height="25" class="td_lmagin"><a href="OprList2Content.jsp?strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=objHshNextInfo.get("DATA_ID")%>">
               <%
           		String strNTitle = BoardComm.replaceTag2Text((String)objHshNextInfo.get("TITLE"));
				String strNDelFlag = (String)objHshNextInfo.get("DEL_FLAG");
				if(strNDelFlag.equals("A") || strNDelFlag.equals("Y")){	//������ �Ǵ� ��ڿ� ���� ���� 
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
	            <td height="20" valign="top">&nbsp;</td>
	          </tr>
              <tr> 
	            <td height="15" valign="top" colspan="2">
	              <!-- ���ñ� ����Ʈ ���� -------------------------------->
	              <% if (strBbrdAnsExt.equals("Y")) { 	//�Խ��� ��� ������ "Y"�� ��츸 ���ñ��� �����ش�.%>
	              <table width="100%" border="0" cellspacing="0" cellpadding="0">
	              <tr> 
	                <td height="2" colspan="5" class="td_forum"></td>
	              </tr>
	              <tr class="td_top"> 
	                <td width="410" height="22" align="center">����</td>
	                <td width="80" height="22" align="center">�����</td>
	                <td width="44" height="22" align="center">����</td>
	                <td width="84" height="22" align="center">�������</td>
	                <td width="62" align="center">��ȸ</td>
	              </tr>
	              <tr> 
	                <td height="1" colspan="5" class="td_forum"></td>
	              </tr>
	              <%
	              if (objAryTtopList != null) {
					for (int i = 0; i < objAryTtopList.size(); i++) {
						Hashtable objHshTtopList = (Hashtable)objAryTtopList.get(i);
                  		
                  		String strTtopDataID = (String)objHshTtopList.get("DATA_ID");
                  		String strTtopTitle = (String)objHshTtopList.get("TITLE");
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
	                	<a href="OprList2Content.jsp?strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=strTtopDataID%>"><%=strTtopTitle%></a>
	                </td>
	                <td height="22" align="center"><%=strTtopFileExtImg%></td>
	                <td height="22" align="center"><%=objHshTtopList.get("USER_NM")%></td>
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
	            <!-- ���ñ� ����Ʈ �� -------------------------------->
	            </td>
	          </tr>
              <tr>
		        <td height="35" colspan="2">
		          	<a href="OprNoticeList.jsp?strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>"><img src="/image/button/bt_list.gif" width="43" height="20" border="0"></a>
		        </td>
		      </tr>
            </form>
            </table>
         	<!-- ��� �������� �󼼺��� ���̺� �� ---------------->  
          </td>
        </tr>
        <tr>
          <td height="10" align="left"></td>
        </tr>
        <tr>
          <td height="15" align="left">
          <!-- ���ٴ�� ���̺� ���� --------------------------------->
          <% if(strBbrdOneExt.equals("Y") && !strDelFlag.equals("A")){ %>
          <table width="590" border="0" cellspacing="0" cellpadding="0">
          <form name="frmOneAns" method="post" action="OprOneAnsProc.jsp?cmd=ONE_CREATE">
		  <input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
		  <input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
		  <input type="hidden" name="dataid" value="<%=strDataID%>">
		  <input type="hidden" name="nowext" value="<%=strOneExt%>">
          <%	
			if(strOneExt.equals("Y")){
				ArrayList objAryOneAnsList = new ArrayList();
				int c=0;
				String strBgColor = "";
				
				try {
					//�������� �Խù��� �ش��ϴ� ��۸���Ʈ�� �����´�.
					objAryOneAnsList = objOprBoard.selectOneAnsList(strDataID);
					
				} catch (AppException objAppEx) {
		
					// ���� �߻� �޼��� �������� �̵��Ѵ�.
					out.println(objAppEx.getStrErrCode());
					out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.");
					return;
					
				}
				
				if(objAryOneAnsList != null){

					int intOneCnt = objAryOneAnsList.size();						//��ü ���ٴ�� ���� 
					//out.print("��ü ��� �� : " + intOneCnt + "<br>");
					
					for(int i=0;i < objAryOneAnsList.size();i++){
						Hashtable objHshOneAnsList = (Hashtable)objAryOneAnsList.get(i);
	
						String strOneUserNm = (String)objHshOneAnsList.get("USER_NM");
						String strOneID = (String)objHshOneAnsList.get("ONE_ANS_ID");
						String strOneDataID = (String)objHshOneAnsList.get("DATA_ID");
						String strOneWord = (String)objHshOneAnsList.get("ONE_WORD");
						String strOneWriterID = (String)objHshOneAnsList.get("WRITER_ID");
						String strOneWriteTs = (String)objHshOneAnsList.get("WRITE_TS");
						strOneWriteTs = strOneWriteTs.substring(0, 4) + ":" + strOneWriteTs.substring(4, 6) 
												+ ":" + strOneWriteTs.substring(6, 8);
						String strOneDelFlag = (String)objHshOneAnsList.get("DEL_FLAG");
						if(strOneDelFlag.equals("A")){
							strOneWord = "�ش���� ���� �Ǿ����ϴ�.";
						}
						
						if(c%2==0){	strBgColor = "bgcolor='#F7F3F8'"; }
						else{ strBgColor = ""; }
						c++;
			  %>
            <tr> 
              <td align="center" <%=strBgColor%>><%=strOneUserNm%><br>
                (<%=strOneWriteTs%>3) </td>
              <td colspan="2" valign="top" <%=strBgColor%> class="td_box"><%=strOneWord%>
				<% if (strUserID.equals(strOneWriterID)){ %>
				<a href="OprOneAnsProc.jsp?strCurrentPage=<%=strCurrentPage%>&cmd=ONE_DELETE&bbrdid=<%=strBbrdID%>&dataid=<%=strDataID%>&oneid=<%=strOneID%>&onecnt=<%=intOneCnt%>"><img src="/image/button/bt_del_board.gif" width="25" height="12" border="0"></a>
				<% } %>
              </td>
            </tr>
            <%
						}	//end for
					}
				}	//end if strOneExt
	  		%>
            <tr valign="top" class="tbl-line">
              <td height="1"></td>
              <td height="1"></td>
              <td height="1"></td>
            </tr>
            <tr> 
              <td width="15%" rowspan="2" bgcolor="E9E9E9" class="td_gray2"><font color="E9E9E9">...</font><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                <span class="soti_forumpop">���� ���</span></td>
              <td width="75%" height="22" valign="bottom" bgcolor="E9E9E9" class="td_lmagin">�ۼ��� : <%=strUserName%> [ �ִ� 100byte(�ѱ� 50��, ���� 100��) ]</td>
              <td width="10%" valign="middle" bgcolor="E9E9E9">&nbsp;</td>     
            </tr>
            <tr>
              <td width="73%" valign="top" bgcolor="E9E9E9" class="td_box"><input name="oneword" type="text" class="textfield" style="WIDTH: 400px"></td>
              <td width="10%" valign="middle" bgcolor="E9E9E9"><img src="/image/button/bt_confirm_icon.gif" width="47" height="19" border="0" style="cursor:hand;" onClick="goToOneSave();"></td>
            </tr>
            </form>
          </table>
          <% } %>
          <!-- ���ٴ�� ���̺� �� --------------------------------->
          </td>
        </tr>
        <tr> 
          <td height="15">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
<%@ include file="/forum/common/BottomForumPop.jsp" %>
</body>
</html>
