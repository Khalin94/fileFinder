<%@ page import="java.util.*" %>

<%
	ArrayList objCommittArry = new ArrayList();//����ȸ
	Hashtable objUserCommittHt = new Hashtable();  
	Hashtable objCommittHt = new Hashtable();  
	
	String strUserCommitt = "";  

	try{
		nads.dsdm.app.main.MainDelegate objMainCommDelegate = new nads.dsdm.app.main.MainDelegate();
		Hashtable objResultHt = objMainCommDelegate.selectUserCommittee(strUserId) ;

		objCommittArry = (ArrayList)objResultHt.get("COMM");
		objUserCommittHt = (Hashtable)objResultHt.get("USERCOMM");
		if(objUserCommittHt != null){
			strUserCommitt = (String)objUserCommittHt.get("REL_ORGAN_ID");
		}
		if(strCommittee.equals("") && objCommittArry.size() > 0){
			objCommittHt = (Hashtable)objCommittArry.get(0);
			strCommittee = (String)objCommittHt.get("ORGAN_ID");
			if (strUserCommitt != null && !strUserCommitt.equals("")){
				strCommittee = strUserCommitt;
			}
		}
	} catch (AppException objAppEx) {
	
		objMsgBean.setMsgType(objMsgBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
%>
			<table width="236" border="0" cellspacing="0" cellpadding="0">
<%
  	String strInOutGbun = (String)session.getAttribute("INOUT_GBN");
  	if(strInOutGbun.equals("I")){
%>              
              <tr> 
                <td height="10" align="center" valign="top"></td>
              </tr>
              <tr> 
                <td align="center" valign="top"><a href="javascript:fun_bottomhomepage('/activity/BizInfo.jsp','�μ��ڷ��')"><img src="image/main/ban_dataroom.gif" width="233" height="30" border="0"></a></td>
              </tr>
              <tr> 
                <td height="7" align="center" valign="top"></td>
              </tr>
              <tr> 
<!--
                <td align="center" valign="top"><a href="javascript:fun_bottomhomepage('http://docs.assembly.go.kr/EP/web/login/assem_sso_login.jsp','��ȸ���ڹ����ý���')"><img src="image/main/ban_elect.gif" width="233" height="30" border="0"></a></td>
-->
                <td align="center" valign="top"><a href="javascript:fun_bottomhomepage('/common/ControlAccess.jsp','��ȸ���ڹ����ý���')"><img src="image/main/ban_elect.gif" width="233" height="30" border="0"></a></td>
              </tr>
              <tr> 
                <td height="7" align="center" valign="top"></td>
              </tr>
              <tr> 
                <td align="center" valign="top"><a href="javascript:fun_bottommail()"><img src="image/main/ban_mail.gif" width="233" height="30" border="0"></a></td>
              </tr>
<%
	}else{
%>
              <tr> 
                <td height="10" align="center" valign="top"></td>
              </tr>
              <tr> 
                <td align="center" valign="top"><a href="javascript:fun_bottomhomepage('http://www.assembly.go.kr/renew07/anc/schedule/formation_vw.jsp','�ǻ�����')"><img src="image/main/ban_agenda.gif" width="233" height="30" border="0"></a></td>
              </tr>
<%
	}
%>
              <tr> 
                <td height="7" align="center" valign="top"></td>
              </tr>
              <tr> 
                <td align="center" valign="top"><a href="javascript:Login('N')"><img src="image/main/ban_messenger.gif" width="233" height="30"  border="0"></a></td>
              </tr>
              
              <tr> 
                <td height="12" align="center" valign="top"></td>
              </tr>
              <tr height="1"> 
                <td align="center" valign="top"><img src="image/main/dotline.gif" width="233" height="1"></td>
              </tr>
              <tr> 
                <td height="12" align="center" valign="top"></td>
              </tr>
              <tr> 
                <td align="center" valign="top">
				  <!-- ���� ����Ʈ ���̺� ���� -->
				  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td align="left" valign="top"><img src="image/main/linksite.gif" width="236" height="31"></td>
                    </tr>
                    <tr height="9"> 
                      <td height="9" align="left" valign="top" background="image/main/bg_linksite.gif"></td>
                    </tr>
                    <tr> 
                      <td align="center" valign="top" background="image/main/bg_linksite.gif">
                        <select name="committee" class="select_links" style="WIDTH: 202px" onchange="fun_chgcomm_1()">
                        	<option>::: ����ȸ Ȩ������</option>
<%
	String strOrganIdLeft = ""; 
	String strOrganNmLeft = "";
	String strHomeUrl = "";
	String strSelected = "";
	int iSelectedChk = 0;
	for(int i=0; i<objCommittArry.size(); i++){
		objCommittHt = (Hashtable)objCommittArry.get(i);
		strOrganIdLeft = (String)objCommittHt.get("ORGAN_ID");
		strOrganNmLeft = (String)objCommittHt.get("ORGAN_NM");
		strHomeUrl = (String)objCommittHt.get("HOME_URL");
		if(strOrganIdLeft.equals(strCommittee)){
			strSelected = "selected";
			iSelectedChk = 1;
		}else{
			strSelected = "";
		}
%>        
        <option value="<%=strOrganIdLeft%>" <%=strSelected%>><%=strOrganNmLeft%></option>
<%
	}
%>                          
                        </select></td>
<% 
	if (iSelectedChk == 0){
%>
<script>
 form_main1.committee.selectedIndex = 0;
</script>
<%
	}
%>                        
                    </tr>
                    <tr height="9"> 
                      <td height="6" align="left" valign="top" background="image/main/bg_linksite.gif"></td>
                    </tr>
                    <tr> 
                      <td align="center" valign="top" background="image/main/bg_linksite.gif">
                        <select name="relorgan" class="select_links" style="WIDTH: 202px" onchange="fun_relhomepage()">
                          <option value=""></option>
                        </select>
                      </td>
						<iframe name="MainRelOrgan" src="/main/MainRelOrgan.jsp" style="display:none;">
                        </iframe>                                              
                    </tr>
                    <tr height="9"> 
                      <td height="6" align="left" valign="top" background="image/main/bg_linksite.gif"></td>
                    </tr>
                    <tr> 
                      <td width="236" align="center" valign="top" background="image/main/bg_linksite.gif">
                        <select name="select2" class="select_links" style="WIDTH: 202px"  onchange="fun_systemhomepage()">
                          <option value="#">::: ��ȸ�����ý���</option>
                          <option value="http://likms.assembly.go.kr">�Թ��������İ����ý���</option>
                          <option value="http://likms.assembly.go.kr/alkms/cgi-bin/counter.cgi?lawscode=1001">�������DB</option>
                          <option value="http://likms.assembly.go.kr/alkms/cgi-bin/counter.cgi?lawscode=2001">��ȸ���������DB</option>
                          <option value="http://likms.assembly.go.kr/alkms/cgi-bin/counter.cgi?lawscode=3001">��ġ���������DB</option>
                          <option value="http://www.assembly.go.kr/renew07/anc/review/off_list.jsp?M_idx=5_01">��ȸ����</option>
                          <option value="http://review.assembly.go.kr">��ȸ��</option>
                          <option value="http://publication.assembly.go.kr:8888/ebook/index.jsp">��ȸ�߰��ڷ�</option>
                          <option value="http://www.assembly.go.kr/renew07/anc/review/lap_list.jsp?M_idx=5_02">�������</option>
                          <option value="http://www.assembly.go.kr/renew07/vr/main.htm">��ȸ�ȳ��ý���</option>
                          <option value="0">--------------</option>
                          <option value="http://www.assembly.go.kr/">��ȸ</option>
                          <option value="http://www.assembly.go.kr/renew07/asm/chr/int.jsp?M_idx=1_01&M_menu=m01_01">��ȸ����</option>
                          <option value="http://www.assembly.go.kr/renew07/mem/index.jsp">��ȸ�ǿ�</option>
                          <option value="http://committee.assembly.go.kr/">����ȸ</option>
                          <option value="http://nas.assembly.go.kr/">��ȸ�繫ó</option>
                          <option value="http://www.nanet.go.kr/">��ȸ������</option>
                          <option value="http://www.nabo.go.kr/">��ȸ������åó</option>
                          <option value="http://memorial.assembly.go.kr/">��������</option>
                        </select></td>
                    </tr>
                    <tr> 
                      <td align="left" valign="top"><img src="image/main/bot_linksite.gif" width="236" height="14"></td>
                    </tr>
                  </table>
				  <!-- ���� ����Ʈ ���̺� �� -->
				</td>
              </tr>
            </table>