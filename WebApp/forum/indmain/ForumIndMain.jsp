<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.forum.SLDBForumDelegate" %>
<%@ page import="nads.dsdm.app.common.code.*" %>
<%@ page import="nads.lib.util.BoardComm" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.lib.util.BoardComm" %>
<%@ page import="nads.lib.session.*" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/> 

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	/*�������� ������ �Ķ���� (����ID, ȸ������, ��������, ������)*/
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); //����ID
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt"))); //ȸ������
	String strOpenFlag = ""; //��������
	String strForumNM = ""; //������

	Hashtable objHashForumData;
	SLDBForumDelegate objDBForum = new SLDBForumDelegate();

	String strForumSort, strForumIntro, strImgPath = "";
	
	try {

		objHashForumData = objDBForum.selectIndForumInfo(strForumID);
		strForumNM = StringUtil.getNVLNULL((String)objHashForumData.get("FORUM_NM"));
		strForumSort = StringUtil.getNVLNULL((String)objHashForumData.get("FORUM_SORT"));
		strOpenFlag = StringUtil.getNVLNULL((String)objHashForumData.get("OPEN_FLAG"));
		strForumIntro = StringUtil.getNVLNULL((String)objHashForumData.get("FORUM_INTRO"));
		strImgPath = StringUtil.getNVLNULL((String)objHashForumData.get("IMG_PATH"));
		String ssss = StringUtil.getNVLNULL((String)objHashForumData.get("FORUM_OPRTR_ID"));
		
		
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

%>
<html>
<head>
<title>�����ڷ� �������� �ý���</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script src='/js/forum.js'></script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/forum/common/MenuTopForumPop.jsp" %>
<table width="800" height="450" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="149" background="/image/forum/bg_forumLeft.gif"> 
<%@ include file="/forum/common/MenuLeftForumPop.jsp" %>
</td>
    <td align="center"><table width="589" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="21" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="center" valign="top"><table width="589" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td align="left" valign="top"><img src="/image/forum/t_top.gif" width="589" height="5"></td>
              </tr>
              <tr> 
                <td align="center" valign="top" background="/image/forum/t_body.gif"><table width="98%" border="0" cellspacing="0" cellpadding="5">
                    <tr>
					  <%
						if (!strForumIntro.equals("")) {
							strForumIntro = BoardComm.replaceTag2Text(strForumIntro);
						}

						if(!strImgPath.equals("")) {
					  %>
						  <td width="29%">
							<img src="<%=strImgPath%>" width="154" height="77">
						  </td>
						  <td width="0%">&nbsp;</td>
						  <td width="71%" class="text"><%=strForumIntro%></td>
					  <%
						} else {
					  %>
						  <td width="100%" class="text" align="left"><%=strForumIntro%></td>
					  <%
						}
					  %>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td align="left" valign="top"><img src="/image/forum/t_bottom.gif" width="589" height="6"></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td align="left" valign="top">&nbsp;</td>
        </tr>
<%
	strIndForumNoticeBbrdID = (strIndForumNoticeBbrdID.equals("")) ? "0000000001":strIndForumNoticeBbrdID;

	ArrayList objAryNotiBbrdData = null; //�������׸��
	ArrayList objAryRcntBbrdData = null; //�ֱٰԽù����
	nads.dsdm.app.board.SLBoardDelegate objForumBoard = new nads.dsdm.app.board.SLBoardDelegate();

	ArrayList objAryBbrdKindData = null; //�Խ�������
	CodeInfoDelegate objCodeInfo = new CodeInfoDelegate(); //�ڵ���� Delegate
						
	try {

		objAryNotiBbrdData = objForumBoard.selectBbrdThreeData("IndNotice",strIndForumNoticeBbrdID,"3");
		objAryRcntBbrdData = objForumBoard.selectBbrdThreeData("IndBoard",strForumID,"3");
		objAryBbrdKindData = objCodeInfo.lookUpCode("M06");

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
%>

        <tr> 
          <td align="left" valign="top"><table width="589" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="395" height="30"><img src="/image/forum/icon_forumpop_soti.gif" width="9" height="9">&nbsp;<span class="soti_forumpop">��������</span></span></td>
                <td width="194" height="25" align="right" class="menu_forumpop"><strong><a href="/forum/indboard/IndBoardList.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&bbrdid=<%=strIndForumNoticeBbrdID%>">[��ü ���]</a>&nbsp;&nbsp;</strong></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="2" colspan="6" class="td_forumpop"></td>
              </tr>
              <tr class="td_top"> 
                <td width="37" height="22" align="center">NO</td>
                <!-- <td width="83" height="22" align="center">����</td> -->
                <td width="348" height="22" align="center">����</td>
                <td width="150" height="22" align="center">�������</td>
                <!-- <td width="68" align="center">�ۼ���</td> -->
                <td width="54" align="center">��ȸ</td>
              </tr>
              <tr> 
                <td height="1" colspan="4" class="td_forumpop"></td>
              </tr>
			<%
			if(objAryNotiBbrdData.size() > 0) {
				for (int i = 0; i < objAryNotiBbrdData.size(); i++) {
					Hashtable objHshNotiBbrdData = (Hashtable)objAryNotiBbrdData.get(i);

					String strBbrdID = (String)objHshNotiBbrdData.get("BBRD_ID");
					String strDataID = (String)objHshNotiBbrdData.get("DATA_ID");
					String strTitle = BoardComm.replaceTag2Text((String)objHshNotiBbrdData.get("TITLE"));
					String strUserNm = (String)objHshNotiBbrdData.get("USER_NM");
					String strWriteTs = (String)objHshNotiBbrdData.get("WRITE_TS");
					String strUpdTs = (String)objHshNotiBbrdData.get("UPD_TS");
					if(!strUpdTs.equals("")){
						strWriteTs = strUpdTs;
					}
					strWriteTs = strWriteTs.substring(0, 4) + "-" + strWriteTs.substring(4, 6) + "-" 
										+ strWriteTs.substring(6, 8);
					String strFileExt = (String)objHshNotiBbrdData.get("APD_FILE_EXT");
					String strFileExtImg = "&nbsp;";
					if(strFileExt.equals("Y")){
						strFileExtImg = "<img src='/image/common/icon_file.gif' width='13' height='15'>";
					}
					String strQryCnt = (String)objHshNotiBbrdData.get("QRY_CNT");
					int intDataLevel = Integer.valueOf((String)objHshNotiBbrdData.get("DATA_LEVEL")).intValue();
					String strDelFlag = (String)objHshNotiBbrdData.get("DEL_FLAG");
					if(strDelFlag.equals("A")){
						strTitle = "�ش���� ���� �Ǿ����ϴ�";
					}

					String strH = "1";
					if (i==objAryNotiBbrdData.size()-1) {
						strH = "2";
					}
			%>
              <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
                <td height="22" align="center"><%=i+1%></td>
                <td height="22" class="td_lmagin">
				  <%
					if(intDataLevel > 0 ){

						String strWid = "";
						
						for(int j=0; j < intDataLevel ; j++){
							strWid = strWid + "&nbsp;&nbsp;&nbsp;";
						}
						out.print(strWid + "<img src='/image/board/icon_reply.gif' border='0'>");		
					
					}

					if(strUserStt.equals("") || strUserStt.equals("N") || strUserStt.equals("NJ")) { //��ȸ�����Դ� �� �󼼺��� �����ȵ�
						out.print(strTitle);
					} else {
				  %>
					  <a href="/forum/indboard/IndList2Content.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&anctgt=0&strCurrentPage=1&bbrdid=<%=strBbrdID%>&dataid=<%=strDataID%>"><%=strTitle%></a>
				  <%
					}
				  %>
				</td>
                <td height="22" align="center"><%=strWriteTs%></td>
                <td align="center"><%=strQryCnt%></td>
              </tr>
              <tr class="tbl-line"> 
                <td height="<%=strH%>"></td>
                <td height="<%=strH%>"></td>
                <td height="<%=strH%>"></td>
                <td height="<%=strH%>"></td>
              </tr>
			<%
				} //end for

			} else {
			%>
				<tr> 
				  <td height="22" colspan=4 align="center">�ش� ����Ÿ�� �����ϴ�.</td>
				</tr>
				<tr class="tbl-line"> 
					<td height="2" colspan=4 align="center"></td>
				</tr>
			<%
			} //end if
			%>
            </table></td>
        </tr>
        <tr> 
          <td align="left" valign="top">&nbsp;</td>
        </tr>
        <tr> 
          <td align="left" valign="top"><table width="589" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="395" height="30"><img src="/image/forum/icon_forumpop_soti.gif" width="9" height="9">&nbsp;<span class="soti_forumpop">�ֱ� �Խù� </span></td>
                <td width="194" height="25" align="right" class="menu_forumpop">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="2" colspan="6" class="td_forumpop"></td>
              </tr>
              <tr class="td_top"> 
                <td width="37" height="22" align="center">NO</td>
                <td width="83" height="22" align="center">�Խ��Ǹ�</td>
                <td width="265" height="22" align="center">����</td>
                <td width="82" height="22" align="center">������</td>
                <td width="68" align="center">�ۼ���</td>
                <td width="54" align="center">��ȸ</td>
              </tr>
              <tr> 
                <td height="1" colspan="6" class="td_forumpop"></td>
              </tr>
			<%
			if(objAryRcntBbrdData.size() > 0) {
				for (int i = 0; i < objAryRcntBbrdData.size(); i++) {
					Hashtable objHshRcntBbrdData = (Hashtable)objAryRcntBbrdData.get(i);

					String strBbrdID = (String)objHshRcntBbrdData.get("BBRD_ID");
					String strDataID = (String)objHshRcntBbrdData.get("DATA_ID");
					String strTitle = BoardComm.replaceTag2Text((String)objHshRcntBbrdData.get("TITLE"));
					String strUserNm = (String)objHshRcntBbrdData.get("USER_NM");
					String strWriteTs = (String)objHshRcntBbrdData.get("WRITE_TS");
					String strUpdTs = (String)objHshRcntBbrdData.get("UPD_TS");
					if(!strUpdTs.equals("")){
						strWriteTs = strUpdTs;
					}
					strWriteTs = strWriteTs.substring(0, 4) + "-" + strWriteTs.substring(4, 6) + "-" 
										+ strWriteTs.substring(6, 8);
					String strFileExt = (String)objHshRcntBbrdData.get("APD_FILE_EXT");
					String strFileExtImg = "&nbsp;";
					if(strFileExt.equals("Y")){
						strFileExtImg = "<img src='/image/common/icon_file.gif' width='13' height='15'>";
					}
					String strQryCnt = (String)objHshRcntBbrdData.get("QRY_CNT");
					int intDataLevel = Integer.valueOf((String)objHshRcntBbrdData.get("DATA_LEVEL")).intValue();
					String strDelFlag = (String)objHshRcntBbrdData.get("DEL_FLAG");
					if(strDelFlag.equals("A")){
						strTitle = "�ش���� ���� �Ǿ����ϴ�";
					}
					
					String strBbrdNM = (String)objHshRcntBbrdData.get("BBRD_NM");

/*
					String strBbrdKind = (String)objHshRcntBbrdData.get("BBRD_KIND");
					for(int j=0; j< objAryBbrdKindData.size(); j++) {
						if(strBbrdKind.equals(String.valueOf(((Hashtable)objAryBbrdKindData.get(j)).get("MSORT_CD")))) {
							strBbrdKind = String.valueOf(((Hashtable)objAryBbrdKindData.get(j)).get("CD_NM"));
							break;
						}
					}
*/
					String strH = "1";
					if (i==objAryRcntBbrdData.size()-1) {
						strH = "2";
					}
			%>
              <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
                <td height="22" align="center"><%=i+1%></td>
                <td height="22" align="center"><%=strBbrdNM%></td>
                <td height="22" class="td_lmagin">
				  <%
					if(intDataLevel > 0 ){

						String strWid = "";
						
						for(int j=0; j < intDataLevel ; j++){
							strWid = strWid + "&nbsp;&nbsp;&nbsp;";
						}
						out.print(strWid + "<img src='/image/board/icon_reply.gif' border='0'>");		
					
					}

					if(strUserStt.equals("") || strUserStt.equals("N") || strUserStt.equals("NJ")) { //��ȸ�����Դ� �� �󼼺��� �����ȵ�
						out.print(strTitle);
					} else {
				  %>
					  <a 	href="/forum/indboard/IndList2Content.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&anctgt=0&strCurrentPage=1&bbrdid=<%=strBbrdID%>&dataid=<%=strDataID%>"><%=strTitle%></a>
				  <%
					}
				  %>
				</td>
                <td height="22" align="center"><%=strWriteTs%></td>
                <td align="center"><%=strUserNm%></td>
                <td align="center"><%=strQryCnt%></td>
              </tr>
              <tr class="tbl-line"> 
                <td height="<%=strH%>"></td>
                <td height="<%=strH%>"></td>
                <td height="<%=strH%>" align="left" class="td_lmagin"></td>
                <td height="<%=strH%>" align="left" class="td_lmagin"></td>
                <td align="left" class="td_lmagin"></td>
                <td align="left" class="td_lmagin"></td>
              </tr>
			<%
				} //end for

			} else {
			%>
				<tr> 
				  <td height="22" colspan=6 align="center">�ش� ����Ÿ�� �����ϴ�.</td>
				</tr>
				<tr class="tbl-line"> 
					<td height="2" colspan=6 align="center"></td>
				</tr>
			<%
			} //end if
			%>
            </table></td>
        </tr>
        <tr> 
          <td height="30" align="left" valign="top">&nbsp;</td>
        </tr>
      </table>
      </td>
  </tr>
</table>
<%@ include file="/forum/common/BottomForumPop.jsp" %>
</body>
</html>
