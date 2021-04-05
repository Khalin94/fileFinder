<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="nads.lib.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.lib.util.*" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	String strMessage = "";
	String strError = "no";
	boolean blnRlt = true;
	Vector objFileRealVt = new Vector();
	String strDeleteDir = "";
	try
	{
		String strUserId = (String)session.getAttribute("USER_ID");
	
		nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();

/***************************************************************************/

		/**** file upload ****/
		FileUpload fileup=new FileUpload(request.getInputStream());

		String strDocboxId = (String)fileup.getParameter("docbox_id");
		String strOrganId = (String)fileup.getParameter("organ_id");
		String strMaxSize = StringUtil.getNVL((String)fileup.getParameter("max_size"), "0");
		String strUsingSize = StringUtil.getNVL((String)fileup.getParameter("using_size"), "0");
			
		if(strMaxSize.equals("")) 	strMaxSize = "0";
		if(strUsingSize.equals("")) 	strUsingSize = "0";
		long lMaxSize = Long.parseLong(strMaxSize);
		long lUsingSize = Long.parseLong(strUsingSize);
					
		String strFile = "";
		String strReal = "";
		String strOpen = "";
		String strRemark = "";
		boolean blntmp = true;
			
		Hashtable objOpenHt = new Hashtable();
		Hashtable objSeqHtable = new Hashtable();
		Vector objParam = new Vector();
		int iResult = 0;

		Vector objRemarkVt = new Vector();  //각 업무정보(파일)에 대한 설명
		Vector objOpenVt = new Vector();     
		Vector objFileVt = new Vector();
		Vector objRealVt = new Vector();
		Vector objSizeVt = new Vector();

		long lSize;
		long lTotSize = 0L;
		int iReturn = 0;

		String strOrgNameTemp = null;
		boolean flag = false;
											
		for(int i=0; i < 5; i++){
			//전체공개 Checkbox의check여부 와 첨부파일 명 조회	
			objOpenHt = fileup.getOpenYn("check2");     //checkbox name ==> check2 : (05/12 :checkbox 삭제)
			strOpen = (String)objOpenHt.get("OPEN");    //전체공개여부 삭제로 '002'로 setting
			strFile =  ActComm.fromDB((String)objOpenHt.get("FILE"));  //업로드 파일명
				
			if (strOpen.equals("001")){ //전체공개에 check 되었을 경우는 파일명을 별도로 조회한다.-->전체공개여부 삭제로 삭제해도 무방--나중을 위해 삭제하지 않음
				strFile  = ActComm.fromDB((String)fileup.getFileName());
			}
			
			strOrgNameTemp = strFile;
			System.out.println("strOrgNameTemp : "+strOrgNameTemp);
			if(strOrgNameTemp != null && !strOrgNameTemp.equals("")&& !strOrgNameTemp.equals("0")){				
				int pos = strOrgNameTemp.lastIndexOf(".");
				//String[] strExtensions = nads.lib.reqsubmit.util.StringUtil.split(".",strOrgNameTemp);
				String strExtension = strOrgNameTemp.substring(pos+1);
				strExtension = strExtension.toLowerCase();
				String[] strEx = {"hwp", "pdf", "zip", "alz", "doc", "ppt", "xls", "txt","xlsx","docx","pptx"};
				
				for(int k = 0; k < strEx.length ; k++){
					if(strEx[k].equals(strExtension)){
						flag = true;
					}
				}
				if(flag == false){
					out.println("<script language=javascript>");
					out.println("alert('hwp,pdf,zip,alz,doc,ppt,xls,txt 형식의 파일만 업로드가능합니다.');");	
					out.println("history.back();");
					out.println("</script>");
					return;
				}			
			}			
			flag = false;

			//업로드 할 파일이 없으면 파일 다음에 있는 설명의 입력란을 읽기만 하고 테이블에 저장을 하지 않음
			if ((strFile == null) || (strFile.length() < 1) || (strFile.equals("0"))) {
				switch (i){
					case 0 :
						strRemark = (String)fileup.getParameter("tx1");  //파일에 대한 설명 조회
						break;
					case 1 :
						strRemark = (String)fileup.getParameter("tx2");
						break;
					case 2 :
						strRemark = (String)fileup.getParameter("tx3");
						break;
					case 3 :
						strRemark = (String)fileup.getParameter("tx4");
						break;
					case 4 :
						strRemark = (String)fileup.getParameter("tx5");
						break;				
				}
				continue;
			} 

			if (strRemark == null) strRemark = "";
			
			/*************** file upload(물리적인 파일을 읽어옴) ***********************************/
			strReal = strUserId + "_" + Integer.toString(i) + "_" + fileup.getKST("yyyyMMddHHmmss") + strFile;
			FileOutputStream upfile = new FileOutputStream(AdminIo.getDefaultDirTmp()  + strReal);
			fileup.UpFile(upfile);
			upfile.close();
			lSize = AdminIo.sizeIo(AdminIo.getDefaultDirTmp()  + strReal);  //파일 사이즈
			/************************************************************/
			if(lSize <= 0){  //파일 사이즈가 '0'일 경우에는 업로드를 하지 않는다.
				strDeleteDir = AdminIo.getDefaultDirTmp() + strReal;
				blnRlt = AdminIo.deleteIo(strDeleteDir) ;
				continue;
			}
			objFileRealVt.add(strReal);
						
			/*******파일 사이즈 제한 ***************************************/
			lTotSize = lTotSize + lSize; 
			//업로드하고자하는 파일들의 크기가 최대 업로드 파일 크기 보다 클 경우 오류메시지 출력
			//업로드하고자하는 파일들의 크기가 사용할수 있는 공간보다 클 경우 오류메시지 출력
			if((lTotSize > lMaxSize) || (lTotSize > lUsingSize)){  
				/**오류 메시지 출력시 업로드된 파일들 삭제 **/			
				if(objFileRealVt != null){
					for(int k=0; k < objFileRealVt.size() ; k++){
						strDeleteDir = AdminIo.getDefaultDirTmp() + (String)objFileRealVt.elementAt(k);
						blnRlt = AdminIo.deleteIo(strDeleteDir) ;
						if (blnRlt == false) continue;
					}
				}
				strMessage = "전송할 파일사이즈가 너무 큽니다";
%>
<script language="javascript">
<!--
	alert("<%=strMessage%>");
	history.back();
//-->
</script>
<%
				return;
			}
			/*************************************************************/

			switch (i){
				case 0 :
					strRemark = ActComm.fromDB((String)fileup.getParameter("tx1"));
					break;
				case 1 :
					strRemark = ActComm.fromDB((String)fileup.getParameter("tx2"));
					break;
				case 2 :
					strRemark = ActComm.fromDB((String)fileup.getParameter("tx3"));
					break;
				case 3 :
					strRemark = ActComm.fromDB((String)fileup.getParameter("tx4"));
					break;
				case 4 :
					strRemark = ActComm.fromDB((String)fileup.getParameter("tx5"));
					break;				
			}
			
			objRemarkVt.add(strRemark);
			objOpenVt.add(strOpen);
			objFileVt.add(strFile);
			objRealVt.add(strReal);
			objSizeVt.add(Long.toString(lSize));
		}//for(int i=0; i < 5; i++)
		
		if (objFileVt.size() >= 1){
			Hashtable objParamHt = new Hashtable();
			objParamHt.put("USERID_ID", (String)strUserId);
			objParamHt.put("DOCBOX_ID", (String)strDocboxId);
			objParamHt.put("ORGAN_ID", (String)strOrganId);
			objParamHt.put("REMARK", (Vector)objRemarkVt);
			objParamHt.put("OPEN", (Vector)objOpenVt);
			objParamHt.put("FILE", (Vector)objFileVt);
			objParamHt.put("REAL", (Vector)objRealVt);
			objParamHt.put("SIZE", (Vector)objSizeVt);
/**************************************************************************/

			int intResult = objBusInfoDelegate.uploadFile(objParamHt);
		
			strMessage = strMessage + String.valueOf(intResult) + "건 생성 되었습니다.";
		}else{
			strMessage = "전송할 파일이 없습니다.";
			strError = "yes";
		}
	}
	catch(AppException objAppEx)
	{	
		if(objFileRealVt != null){
			for(int k=0; k < objFileRealVt.size() ; k++){
				strDeleteDir = AdminIo.getDefaultDirTmp() + (String)objFileRealVt.elementAt(k);
				blnRlt = AdminIo.deleteIo(strDeleteDir) ;
				if (blnRlt == false) continue;
			}
		}
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
		strError = "yes";
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
%>

<script language="javascript">
<!--
	alert("<%=strMessage%>");
		
	<%if(strError.equals("no")){%>
	opener.location.reload();
    self.window.close(); 
	<%}else{%>
	history.back();
	<%}%>
//-->
</script>
