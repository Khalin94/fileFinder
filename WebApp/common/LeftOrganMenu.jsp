<%
	//���û���Ʈ ���� =========================
	
	String strCommitteeLeft = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(kr.co.kcc.bf.bfutil.StringUtil.getNVL(request.getParameter("comm"), ""));
	
	ArrayList objCommittArryLeft = new ArrayList();			//����ȸ
	Hashtable objUserCommittHtLeft = new Hashtable();  
	Hashtable objCommittHtLeft = new Hashtable();  
	ArrayList objRelOrganArryLeft = new ArrayList();		//���ñ��
	Hashtable objRelOrganHtLeft = new Hashtable();
	
	String strUserCommittLeft = "";  

	try{
		nads.dsdm.app.main.MainDelegate objMainCommDelegate = new nads.dsdm.app.main.MainDelegate();
		Hashtable objResultHtLeft = objMainCommDelegate.selectUserCommittee((String)session.getAttribute("USER_ID")) ;

		objCommittArryLeft = (ArrayList)objResultHtLeft.get("COMM");
		objUserCommittHtLeft = (Hashtable)objResultHtLeft.get("USERCOMM");
		if(objUserCommittHtLeft != null){
			strUserCommittLeft = (String)objUserCommittHtLeft.get("REL_ORGAN_ID");
		}
		if(strCommitteeLeft.equals("") && objCommittArryLeft.size() > 0){
			objCommittHtLeft = (Hashtable)objCommittArryLeft.get(0);
			strCommitteeLeft = (String)objCommittHtLeft.get("ORGAN_ID");
			if (strUserCommittLeft != null && !strUserCommittLeft.equals("")){
				strCommitteeLeft = strUserCommittLeft;
			}
		}
		
		//���ñ�� Ȩ������ ������ �����´�.(ó�� �ε��ÿ���..)
		if(!strCommitteeLeft.equals("")){
			objRelOrganArryLeft = objMainCommDelegate.selectRelOrgan(strCommitteeLeft, "");
		}
		
	} catch (AppException objAppEx) {
%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
	}
	
	//���û���Ʈ �� =========================
%>
<table width="173" border="0" cellspacing="0" cellpadding="0">
	
  <form name="form_main1" method="post" action="" >
    <tr> 
      <td align="left" valign="top"><img src="/image/common/linksite_sub.gif" width="173" height="30"></td>
    </tr>
    <tr height="9"> 
      <td height="9" align="left" valign="top" background="/image/common/bg_linksite_sub.gif"></td>
    </tr>
    <tr> 
      <td align="center" valign="top" background="/image/common/bg_linksite_sub.gif">
      	<select name="committee" class="text_s" style="WIDTH: 153px" onChange="fun_chgcomm_1()">
      		<option>::: ����ȸ Ȩ������</option>
<%
	String strOrganIdLeft = ""; 
	String strOrganNmLeft = "";
	String strHomeUrlLeft = "";
	String strSelectedLeft = "";
	for(int i=0; i<objCommittArryLeft.size(); i++){
		objCommittHtLeft = (Hashtable)objCommittArryLeft.get(i);
		strOrganIdLeft = (String)objCommittHtLeft.get("ORGAN_ID");
		strOrganNmLeft = (String)objCommittHtLeft.get("ORGAN_NM");
		strHomeUrlLeft = (String)objCommittHtLeft.get("HOME_URL");
		if(strOrganIdLeft.equals(strCommitteeLeft)){
			strSelectedLeft = "selected";
		}else{
			strSelectedLeft = "";
		}
%>               	
              <option value="<%=strOrganIdLeft%>" <%=strSelectedLeft%>><%=strOrganNmLeft%></option>
<%
	}
%>              
        </select></td>
    </tr>
    <tr height="9"> 
      <td height="6" align="left" valign="top" background="/image/common/bg_linksite_sub.gif"></td>
    </tr>
    <tr> 
      <td align="center" valign="top" background="/image/common/bg_linksite_sub.gif">
      	<select name="relorgan" class="text_s" style="WIDTH: 153px" onChange="fun_relhomepage()">
      	  <option>::: ���ñ�� Ȩ������</option>
<%
	for(int j=0; j<objRelOrganArryLeft.size(); j++){
		objRelOrganHtLeft = (Hashtable)objRelOrganArryLeft.get(j);
		strOrganIdLeft = (String)objRelOrganHtLeft.get("ORGAN_ID");
		strOrganNmLeft = (String)objRelOrganHtLeft.get("ORGAN_NM");
		strHomeUrlLeft = (String)objRelOrganHtLeft.get("HOME_URL");
%>
        <option value="<%=strHomeUrlLeft%>"><%=strOrganNmLeft%></option>
<%
	}
%>              
        </select></td>
    </tr>
    <iframe name="MainRelOrgan" src="/main/MainRelOrgan.jsp" style="display:none;"></iframe>   
    <tr height="9"> 
      <td height="6" align="left" valign="top" background="/image/common/bg_linksite_sub.gif"></td>
    </tr>
    <tr> 
      <td width="236" align="center" valign="top" background="/image/common/bg_linksite_sub.gif">
      	<select name="select2" class="text_s" style="WIDTH: 153px" onChange="fun_systemhomepage()">
      	  <option>::: ��ȸ�����ý���</option>
          <option value="http://likms.assembly.go.kr">�Թ��������İ����ý���</option>
          <option value="http://likms.assembly.go.kr/alkms/cgi-bin/counter.cgi?lawscode=1001">�������DB</option>
          <option value="http://likms.assembly.go.kr/alkms/cgi-bin/counter.cgi?lawscode=2001">��ȸ���������DB</option>
          <option value="http://likms.assembly.go.kr/alkms/cgi-bin/counter.cgi?lawscode=3001">��ġ���������DB</option>
          <option value="http://www.assembly.go.kr:8000/oth/html/index_1.html">��ȸ����</option>
          <option value="http://review.assembly.go.kr">��ȸ��</option>
          <option value="http://publication.assembly.go.kr:8888/ebook/index.jsp">��ȸ�߰��ڷ�</option>
          <option value="http://www.assembly.go.kr:8000/oth/html/index_2.html">�������</option>
          <option value="http://www.assembly.go.kr:8000/guide/index.html">��ȸ�ȳ��ý���</option>
          <option value="0">--------------</option>
          <option value="http://www.assembly.go.kr/">��ȸ</option>
          <option value="http://www.assembly.go.kr:8000/chr/html/index.html">��ȸ����</option>
          <option value="http://www.assembly.go.kr:8000/mem/html/index.html">��ȸ�ǿ�</option>
          <option value="http://committee.assembly.go.kr/">����ȸ</option>
          <option value="http://nas.assembly.go.kr/">��ȸ�繫ó</option>
          <option value="http://www.nanet.go.kr/">��ȸ������</option>
          <option value="http://www.nabo.go.kr/">��ȸ������åó</option>
          <option value="http://memorial.assembly.go.kr/">��������</option>
        </select></td>
    </tr>
    <tr> 
      <td align="left" valign="top"><img src="/image/common/bot_linksite_sub.gif" width="173" height="13"></td>
    </tr> 
    </form>
</table>