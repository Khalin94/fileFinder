<table width="149" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td height="15" align="left" valign="top">&nbsp;</td>
  </tr>
  <tr> 
    <td align="center" valign="top"><table width="100" border="0" cellspacing="0" cellpadding="0">
<%
	if(strUserStt.equals("") || strUserStt.equals("N")) { //���Թ�ư : ��ȸ��
%>
        <tr> 
          <td align="left" valign="top"><a href="javascript:openWinB('/forum/induser/ForumJoinreq.jsp?fid=<%=strForumID%>&openYN=<%=strOpenFlag%>&fnm=<%=strForumNM%>&loc=Ind','winJoin','380','300');"><img src="/image/forum/bt_forumJoin.gif" width="103" height="26" border="0"></a></td>
        </tr>
        <!-- <tr> 
          <td height="3" align="left" valign="top"></td>
        </tr> -->
<%
	} else if(strUserStt.equals("Y")) { //Ż���ư : �Ϲ�ȸ��
%>
        <tr> 
          <td align="left" valign="top"><a href="javascript:openWinB('/forum/induser/ForumLeavereq.jsp?fid=<%=strForumID%>&fnm=<%=strForumNM%>&loc=Ind&cmd=leaveReq','winJoin','380','280');"><img src="/image/forum/bt_forumBreak.gif" width="103" height="26" border="0"></a></td>
        </tr>
<%
	}
%>
      </table></td>
  </tr>
  <tr> 
    <td height="10" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td height="14" align="center" valign="top"><table width="134" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td align="left" valign="top"><img src="/image/forum/box_top.gif" width="134" height="4"></td>
        </tr>
        <tr> 
          <td align="center" valign="top" background="/image/forum/bg_boxBody.gif"><table width="126" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="5" colspan="2" valign="middle" class="copy_b"></td>
              </tr>
              <tr> 
                <td width="21" height="18" align="right" valign="middle" class="menu_forumpop"><img src="/image/forum/icon_dot.gif" width="5" height="6" align="absmiddle">&nbsp;</td>
                <td height="25" valign="middle" class="menu_forumpop"><strong><a href="/forum/induser/ForumUserList.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>">ȸ�����</a></strong></td>
              </tr>
<%
	String strIndForumNoticeBbrdID = null; //���ο��� ���
	ArrayList objAryForumBbrdMenu = null;
	nads.dsdm.app.forum.SLMngBoardDelegate objForumBoardMenu = new nads.dsdm.app.forum.SLMngBoardDelegate();
	
	try {

		objAryForumBbrdMenu = objForumBoardMenu.selectIndForumBoardList(strForumID);
		
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

	for (int i = 0; i < objAryForumBbrdMenu.size(); i++) {
		Hashtable objHshForumBbrdMenu = (Hashtable)objAryForumBbrdMenu.get(i);

		String strMenuBbrdID = (String)objHshForumBbrdMenu.get("BBRD_ID");
		String strMenuBbrdNM = (String)objHshForumBbrdMenu.get("BBRD_NM"); //�Խ��Ǹ�
		String strMenuBbrdKind = (String)objHshForumBbrdMenu.get("BBRD_KIND"); //�Խ�������
		String strMenuRemark = (String)objHshForumBbrdMenu.get("REMARK"); //���

		if(strMenuBbrdKind.equals("001") && strMenuRemark.equals("ADMIN")) {
			strIndForumNoticeBbrdID = strMenuBbrdID;
		}
%>
              <tr> 
                <td height="1" colspan="2" align="center"><img src="/image/forum/line_gray.gif" width="126" height="1"></td>
              </tr>
              <tr> 
                <td width="21" height="18" align="right" valign="middle" class="menu_forumpop"><img src="/image/forum/icon_dot.gif" width="5" height="6" align="absmiddle">&nbsp;</td>
                <td height="25" valign="middle"  class="menu_forumpop"><strong><a href="/forum/indboard/IndBoardList.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&bbrdid=<%=strMenuBbrdID%>"><%=strMenuBbrdNM%></a></strong></td>
              </tr>
<%
	} //end for
%>
            </table></td>
        </tr>
        <tr> 
          <td align="left" valign="top"><img src="/image/forum/box_bottom.gif" width="134" height="4"></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="10" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td height="16" align="center" valign="top"><table width="134" border="0" cellspacing="0" cellpadding="0">
<%
	if(strUserStt.equals("OO") || strUserStt.equals("CO")) { //����� ���
	
	//��ü���� ��� ���������� �����´�.
	nads.dsdm.app.board.SLBoardDelegate objBoardMenu = new nads.dsdm.app.board.SLBoardDelegate();
	Hashtable objHashMenuBoardID = null;
	String strMenuOprBbrdID = null;
	
	try {

		objHashMenuBoardID =  objBoardMenu.selectIndBoardID("998");
		
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
	
	if (objHashMenuBoardID.size() != 0) {
		//Hashtable objHshBbrdMenu = (Hashtable)objAryBbrdMenu.get(0);
		strMenuOprBbrdID = (String)objHashMenuBoardID.get("BBRD_ID");	
	}
%>
        <tr> 
          <td align="left" valign="top"><table width="134" height="25" border="0" cellpadding="0" cellspacing="1" bgcolor="C3C3C3">
              <tr> 
                <td width="125" height="14" align="center" valign="middle" bgcolor="D8E1F0"><a href="/forum/indboard/IndBoardList.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&bbrdid=<%=strMenuOprBbrdID%>&anctgt=1">��� �������� </a></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="3" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top"><table width="134" height="25" border="0" cellpadding="0" cellspacing="1" bgcolor="C3C3C3">
              <tr> 
                <td width="125" height="14" align="center" valign="middle" bgcolor="D8E1F0"><a href="/forum/indbrdinfo/ManageBoardList.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>">�Խ��� 
                  ����</a> </td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="8" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top"><table width="134" height="25" border="0" cellpadding="0" cellspacing="1" bgcolor="C3C3C3">
              <tr> 
                <td width="125" height="14" align="center" valign="middle" bgcolor="D8E1F0"><a href="/forum/induser/ForumUserList.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&gbn=O">���ε� 
                  ȸ��</a></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="3" align="left" valign="top"></td>
        </tr>
<%
		if(strUserStt.equals("CO")) { //����������� ��� ���
%>
			<tr> 
			  <td align="left" valign="top"><table width="134" height="25" border="0" cellpadding="0" cellspacing="1" bgcolor="C3C3C3">
				  <tr> 
					<td width="125" height="14" align="center" valign="middle" bgcolor="D8E1F0"><a href="/forum/induser/ForumReqUserList.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&gbn=jReq">���� ��û ȸ��</a></td>
				  </tr>
				</table></td>
			</tr>
			<tr> 
			  <td height="3" align="left" valign="top"></td>
			</tr>
<%
		}
%>
        <tr> 
          <td align="left" valign="top"><table width="134" height="25" border="0" cellpadding="0" cellspacing="1" bgcolor="C3C3C3">
              <tr> 
                <td width="125" height="14" align="center" valign="middle" bgcolor="D8E1F0"><a href="/forum/induser/ForumReqUserList.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&gbn=lReq">Ż�� ��û ȸ��</a></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="8" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top"><table width="134" height="25" border="0" cellpadding="0" cellspacing="1" bgcolor="C3C3C3">
              <tr> 
                <td width="125" height="14" align="center" valign="middle" bgcolor="D8E1F0"><a href="/forum/indinfo/ForumIndInfo.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>">������� ����</a></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="3" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top"><table width="134" height="25" border="0" cellpadding="0" cellspacing="1" bgcolor="C3C3C3">
              <tr> 
                <td width="125" height="14" align="center" valign="middle" bgcolor="D8E1F0"><a href="javascript:openWinB('/forum/indinfo/ForumClosereq.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&fnm=<%=strForumNM%>','winJoin','380','280');">����û</a></td>
              </tr>
            </table></td>
        </tr>
<%
	}
%>
      </table></td>
  </tr>
  <tr> 
    <td height="16" align="left" valign="top"></td>
  </tr>
</table>