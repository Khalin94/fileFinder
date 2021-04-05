<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.io.* "%>
<%@ page import="kr.co.kcc.bf.db.DBAccess"%>
<%@ page import="kr.co.kcc.bf.db.DBAccessException"%>
<%@ page import="nads.lib.util.* "%>
<%@ page import="nads.lib.reqsubmit.util.* "%>
<%@ page import="nads.lib.db.sql.* "%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%@ include file="/common/CheckSession.jsp" %>

<%
    String strMessage = "";
    String strError = "no";
    DBAccess objDAO = null;
    int intResult = 0;

    try
    {
        String strUserId = (String)session.getAttribute("USER_ID");
        nads.dsdm.app.activity.userinfo.UserInfoDelegate objUserInfoDelegate = new nads.dsdm.app.activity.userinfo.UserInfoDelegate() ;
        //int intResult = objUserInfoDelegate.updateTest(request.getInputStream(), strUserId);
        //int intResult = objUserInfoDelegate.updateUserInfo(request.getInputStream(), strUserId);
        //--out.println("Result : " + intResult);
        strMessage = "변경 되었습니다.";
        //--response.sendRedirect("SendFax.jsp");
        objDAO = new DBAccess(this.getClass());
        Vector objParamVector = new Vector();
        String strSQL = "UPDATE tbdm_user_info "
              + "SET dept_nm = ?, "
              + "       email = ?, "
              + "       office_tel = ?, "
              + "       fax_no = ?, "
              + "       cphone = ?, "
              + "       post_cd = ?, "
              + "       juso1 = ?, "
              + "       juso2 = ?, "
              + "       cg_duty = ?, "
              + "       photo_path = ?, "
              + "       remark = ?, "
              + "       upd_ts =  to_char(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3'), "
              + "       updr_id = ?, "
              + "       innerphone = ?, "
              + "       grd_nm = ? "
              + "WHERE user_id = ? " ;
        String strSQLPHOTE = SqlUserInfo.getUserInfoSelectPhotoFile();

        /**** file upload ****/
        FileUpload fileup=new FileUpload(request.getInputStream());

        String strOrganId = ActComm.fromDB((String)fileup.getParameter("organ_id"));
        String strDeptNm = ActComm.fromDB((String)fileup.getParameter("dept_nm"));
		String strPosiNm = ActComm.fromDB((String)fileup.getParameter("posi_nm"));
		String strGrdNm = ActComm.fromDB((String)fileup.getParameter("grd_nm"));		
        String strEmail = ActComm.fromDB((String)fileup.getParameter("email"));
        String strOfficeTel1 = ActComm.fromDB((String)fileup.getParameter("office_tel1"));
        String strOfficeTel2 = ActComm.fromDB((String)fileup.getParameter("office_tel2"));
        String strOfficeTel3 = ActComm.fromDB((String)fileup.getParameter("office_tel3"));
        String strInnerPhone = ActComm.fromDB((String)fileup.getParameter("innerphone"));
        String strFaxNo1 = ActComm.fromDB((String)fileup.getParameter("fax_no1"));
        String strFaxNo2 = ActComm.fromDB((String)fileup.getParameter("fax_no2"));
        String strFaxNo3 = ActComm.fromDB((String)fileup.getParameter("fax_no3"));
        String strCphone1 = ActComm.fromDB((String)fileup.getParameter("cphone1"));
        String strCphone2 = ActComm.fromDB((String)fileup.getParameter("cphone2"));
        String strCphone3 = ActComm.fromDB((String)fileup.getParameter("cphone3"));
        /* String strPostCd1 = ActComm.fromDB((String)fileup.getParameter("post_cd1"));
        String strPostCd2 = ActComm.fromDB((String)fileup.getParameter("post_cd2")); */
        String strPostCd = ActComm.fromDB((String)fileup.getParameter("post_cd"));
        String strJuso1 = ActComm.fromDB((String)fileup.getParameter("juso1"));
        String strJuso2 = ActComm.fromDB((String)fileup.getParameter("juso2"));
        String strCgDuty = "";
//            String strCgDuty = ActComm.fromDB((String)fileup.getParameter("cg_duty"));
//            String strRepFlag = ActComm.fromDB((String)fileup.getParameter("rep_yn"));
        Hashtable objChargeHt = (Hashtable)fileup.getCharge();
        Vector objMVt = (Vector)objChargeHt.get("MCHR");   //주업무
        Vector objSVt = (Vector)objChargeHt.get("SCHR");    // 부업무
        String strMChgRk = ActComm.fromDB((String)objChargeHt.get("MRK"));   //주업무 -- 기타업무
        String strSChgRk = ActComm.fromDB((String)objChargeHt.get("SRK"));    //부업무 -- 기타업무
        String strRep = ActComm.fromDB((String)objChargeHt.get("REP"));    //대표자 여부('Y':대표자, 'N':대표자가 아님)
        String strPhotoPath = ActComm.fromDB((String)objChargeHt.get("FILE"));

        System.out.println("strPhotoPath ====> "+strPhotoPath);
        if(strPhotoPath != null && !strPhotoPath.equals("")){
            boolean flag = false;
            String[] strExtensions = nads.lib.reqsubmit.util.StringUtil.split(".",strPhotoPath);
            String strExtension = strExtensions[1];
            strExtension = strExtension.toLowerCase();
            String[] strEx = {"gif","jpg","jpeg","bmp","png"};

            for(int i = 0; i < strEx.length ; i++){
                if(strEx[i].equals(strExtension)){
                    flag = true;
                }
            }

            if(flag == false){
                out.println("<script language=javascript>");
                out.println("alert('gif,jpg,jpeg,bmp,png 형식의 파일만 업로드가능합니다.');");
                out.println("history.go(-1);");
                out.println("</script>");
                return;
            }
        }
        //대표자 여부 수정
        if((strRep != null) && (!strRep.equals(""))){
            Vector objRepParamVt = new Vector();
            objRepParamVt.add(strRep);
            objRepParamVt.add(strUserId);
            objRepParamVt.add(strPosiNm);
            objRepParamVt.add(strOrganId);
            objRepParamVt.add(strUserId);

            //int RepResult = objUserInfoDelegate.updateRepFlag(objRepParamVt);
            String strSQL2 = SqlBrgDept.getBusInfoUpdateRepFlag() ;

            objDAO.setSQL(strSQL2, objRepParamVt);
            intResult = objDAO.doUpdate() ;
        }


        //기존사진파일를 조회한다.
        objParamVector.add(strUserId);
        objDAO.setSQL(strSQLPHOTE, objParamVector);
        objDAO.doQuery() ;
        Hashtable objPhoteHt = objDAO.getSingleHashtable() ;
        String strOrgPhote = (String)objPhoteHt.get("PHOTO_PATH");

        /*************** file upload ***********************************/
        String strReal = "";
        if((strPhotoPath != null) && (!strPhotoPath.equals(""))){
            strReal = strUserId + "." + fileup.getKST("yyyyMMddHHmmss");
            FileOutputStream upfile = new FileOutputStream(AdminIo.getWebappPath() + AdminIo.getPhoteDir()  + strReal);
            fileup.UpFile(upfile);
            upfile.close();

            long lSize = AdminIo.sizeIo(AdminIo.getWebappPath() + AdminIo.getPhoteDir()  + strReal);
            if (lSize < 1){
                boolean blnRlt = AdminIo.deleteIo(AdminIo.getWebappPath() + AdminIo.getPhoteDir()  + strReal) ;
                strReal = strOrgPhote;
            }else{
                if(!strOrgPhote.equals("")){
                    boolean blnRlt = AdminIo.deleteIo(AdminIo.getWebappPath() + AdminIo.getPhoteDir()  + strOrgPhote) ;
                }
                strReal = AdminIo.getPhoteDir()  + strReal;
            }
        }else{
            strReal = strOrgPhote; //사진변경이 없으면 물리적으로는 수정을 하지 않는다.
        }

        String strRemark = ActComm.fromDB((String)fileup.getRemark("remark"));
        //String strPostCd = strPostCd1 + strPostCd2;

        String strFaxNo = "";
        if(!strFaxNo1.equals("")) strFaxNo = strFaxNo1;
        if(!strFaxNo2.equals("")) strFaxNo = strFaxNo + "-" + strFaxNo2;
        if(!strFaxNo3.equals("")) strFaxNo = strFaxNo + "-" + strFaxNo3;

        String strCphone = "";
        if(!strCphone1.equals("")) strCphone = strCphone1;
        if(!strCphone2.equals("")) strCphone = strCphone + "-" + strCphone2;
        if(!strCphone3.equals("")) strCphone = strCphone + "-" + strCphone3;
        String strOfficeTel = "";
        if(!strOfficeTel1.equals("")) strOfficeTel = strOfficeTel1;
        if(!strOfficeTel2.equals("")) strOfficeTel = strOfficeTel + "-" + strOfficeTel2;
        if(!strOfficeTel3.equals("")) strOfficeTel = strOfficeTel + "-" + strOfficeTel3;
        Hashtable objChrHt = new Hashtable();
        objChrHt.put("M", objMVt);
        objChrHt.put("S", objSVt);
        objChrHt.put("MRK", strMChgRk);
        objChrHt.put("SRK", strSChgRk);
        objUserInfoDelegate.insertUserCharge(strUserId, objChrHt);
        objParamVector.clear() ;
		System.out.println("strCphone : "+strCphone);
        objParamVector.add(StringUtil.getEmptyIfNull(strDeptNm));
        objParamVector.add(StringUtil.getEmptyIfNull(strEmail));
        objParamVector.add(StringUtil.getEmptyIfNull(strOfficeTel));
        objParamVector.add(StringUtil.getEmptyIfNull(strFaxNo));
        objParamVector.add(StringUtil.getEmptyIfNull(strCphone));
        objParamVector.add(StringUtil.getEmptyIfNull(strPostCd));
        objParamVector.add(StringUtil.getEmptyIfNull(strJuso1));
        objParamVector.add(StringUtil.getEmptyIfNull(strJuso2));
        objParamVector.add(strCgDuty);
        objParamVector.add(strReal);
        objParamVector.add(StringUtil.getEmptyIfNull(strRemark));
        objParamVector.add(strUserId);
        objParamVector.add(StringUtil.getEmptyIfNull(strInnerPhone));
		objParamVector.add(StringUtil.getEmptyIfNull(strGrdNm));		
        objParamVector.add(strUserId);
        objDAO.init() ;
        objDAO.setSQL(strSQL, objParamVector);
        intResult = objDAO.doUpdate() ;
    }
    catch(AppException objAppEx)
    {
        objMsgBean.setMsgType(MessageBean.TYPE_ERR);
          objMsgBean.setStrCode(objAppEx.getStrErrCode());
          objMsgBean.setStrMsg(objAppEx.getMessage());
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
    location.href="http://naps.assembly.go.kr/main.jsp";
    //location.href="http://10.201.13.21:9000/main.jsp";
    <%}else{%>
    history.back();
    <%}%>
//-->
</script>
