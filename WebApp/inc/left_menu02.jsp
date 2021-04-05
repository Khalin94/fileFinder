<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%
	String strOrgGBN = objUserInfo.getOrganGBNCode();
	String strIsRequester = String.valueOf(objUserInfo.isRequester());
	String strImgName = null;
    String strsession = (String)session.getAttribute("clickno")==null?"22":(String)session.getAttribute("clickno");
    String clickno = request.getParameter("clickno")==null?strsession:request.getParameter("clickno");
    session.setAttribute("clickno",clickno);
	if ("true".equalsIgnoreCase(strIsRequester)) strImgName = "req";
	else strImgName = "submit";

	// 2005-07-29 kogaeng ADD
	String strMenuCmtOrganID = "";
	if("004".equalsIgnoreCase(strOrgGBN)) {
		strMenuCmtOrganID = (String)objUserInfo.getOrganID();
	} else if ("003".equalsIgnoreCase(strOrgGBN)) {
		if(nads.lib.reqsubmit.util.StringUtil.isAssigned(request.getParameter("CmtOrganID"))) {
			strMenuCmtOrganID = request.getParameter("CmtOrganID");
		} else {

			if((objUserInfo.getCurrentCMTList()).size() > 0){
				strMenuCmtOrganID = "";
			}else{

			}

		}
	}
	System.out.println("strMenuCmtOrganID : "+strMenuCmtOrganID);
%>
<script src="/js/reqsubmit.js"></script>
<script src="/js/leftmenu.js"></script>
<script language="JavaScript">
	var NS4 = (document.layers);
	var IE4 = (document.all);
	var win = window;
	var n   = 0;


	function fun_bottomhomepage(strUrl, strNm){
		window.open(strUrl, strNm);
	}
	function menuOpenFold(id){
		if(document.getElementById(id).style.display == "none"){
			document.getElementById(id).style.display = "";
		} else {
			document.getElementById(id).style.display = "none"
		}
	}
</script>

<div id="left_menu">
<%if("true".equals(strIsRequester)){ %>
  <h2><img src="/images2/foundation/tl02.gif"  /></h2>
<%} else {%>
  <h2><img src="/images2/foundation/tl02_2.gif"  /></h2>
<%}%>
  <ul>
	<!------------------------------------------- MENU SCRIPT START ------------------------------------------->
<%
	String strFileName = nads.lib.reqsubmit.util.FileUtil.getFileName(request.getRequestURI(), "/");
	nads.dsdm.app.reqsubmit.delegate.common.MenuDelegate objMenu = new nads.dsdm.app.reqsubmit.delegate.common.MenuDelegate();
	nads.dsdm.app.reqsubmit.delegate.cmtmanager.CmtManagerConfirmDelegate objCmtMngBean = new nads.dsdm.app.reqsubmit.delegate.cmtmanager.CmtManagerConfirmDelegate();

	boolean blnMngUse = false;
	if(nads.lib.reqsubmit.util.StringUtil.isAssigned(strMenuCmtOrganID)) blnMngUse = (objCmtMngBean.getFLAG(strMenuCmtOrganID) > 1) ? true : false;
	else blnMngUse = false;

	nads.lib.reqsubmit.util.ResultSetHelper objMenuRs = null;
	nads.lib.reqsubmit.util.ResultSetSingleHelper objMenuRsSH = null;
	try {
		java.util.Hashtable hashOrgMenu = null;
		hashOrgMenu = (java.util.Hashtable)objMenu.getOrgMenuList(strOrgGBN, strIsRequester);
		objMenuRs = new nads.lib.reqsubmit.util.ResultSetHelper(hashOrgMenu);
		System.out.println("request.getRequestURI() : "+request.getRequestURI());
		System.out.println("strOrgGBN : "+strOrgGBN);
		objMenuRsSH = new nads.lib.reqsubmit.util.ResultSetSingleHelper(objMenu.getRefDepthID(request.getRequestURI(), strOrgGBN));

        int index=0;
        int j=0;
        String strliYn1 = "N";
        String strliYn2 = "N";
        String strliYn3 = "N";

        String strulYn2 = "N";
        String strulYn3 = "N";


        String strMenuIdOld1 = "";
        String strMenuIdOld2 = "";

        String stroldMenu="";
        String strMenu="";
        String a = "";
        String viewyn = "0";

        if(objMenuRs.next()) {
            a="0";
        } else {
 		    a="";
        }
        while(a.equals("0")) {
	 		String strMenuID = (String)objMenuRs.getObject("REQ_MENU_ID");
	 		String strMenuName = (String)objMenuRs.getObject("REQ_MENU_NM");
	 		String strRefMenuID = (String)objMenuRs.getObject("REF_ID");
	 		String strMenuPath = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull((String)objMenuRs.getObject("REQ_MENU_PATH"));
	 		String strMenuFileName = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull((String)objMenuRs.getObject("REQ_MENU_FILE_NAME"));
	 		String strMenuIndex = (String)objMenuRs.getObject("REF_MENU_INDEX");
	 		String strMenuDepth = (String)objMenuRs.getObject("MENU_DEPTH");
	 		String strOrderNum = (String)objMenuRs.getObject("ORDER_NUM");

	 		String strMenuParam = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull((String)objMenuRs.getObject("REQ_MENU_PARAM"));
	 		if (nads.lib.reqsubmit.util.StringUtil.isAssigned(strMenuParam)) {
                if (strMenuName.equals("비전자문서 요구등록")||strMenuName.equals("요구함 작성")){
    	 			strMenuParam = "?"+strMenuParam+"&clickno=11";
                } else {
    	 			strMenuParam = "?"+strMenuParam+"&clickno=9999";
                }
	 		} else {
	 			strMenuParam = "?clickno="+strMenu;
	 		}

            if (strMenuDepth.equals("1")){
                if (strulYn3.equals("Y")){
                    out.println("</li></ul>");
                    strulYn3 = "N";
                    strliYn3 = "N";
                }
                if (strulYn2.equals("Y")){
                    out.println("</li></ul>");
                    strulYn2 = "N";
                    strliYn2 = "N";
                }
                if (strliYn1.equals("Y")){
                    strliYn1 = "N";
                    out.println("</li>");
                }
                if (strliYn1.equals("N")){
                    strliYn1 = "Y";
                    out.println("<li>");
                }
            } else if (strMenuDepth.equals("2")){
                if (strulYn3.equals("Y")){
                    out.println("</li></ul>");
                    strulYn3 = "N";
                    strliYn3 = "N";
                }
                if (strulYn2.equals("N")){
                    strulYn2 = "Y";
                    out.print("<ul class='dep3' id='"+stroldMenu+"'");
                    if (clickno.length()!=stroldMenu.length()){
                        out.print(" style='display:none;'");
                    }
                    out.print(">");
                }
                if (strliYn2.equals("Y")){
                    strliYn2 = "N";
                    out.println("</li>");
                }
                if (strliYn2.equals("N")){
                    strliYn2 = "Y";
                    out.println("<li>");
                }
            } else if (strMenuDepth.equals("3")){
                if (strulYn3.equals("N")){
                    strulYn3 = "Y";
                    out.println("<ul class='dep4' id='"+stroldMenu+"'");
                    if (!clickno.equals(stroldMenu)){
                        out.print(" style='display:none;'");
                    }
                    out.print(">");
                    strMenuIdOld2 = strRefMenuID;
                }
                if (strliYn3.equals("Y")){
                    strliYn3 = "N";
                    out.println("</li>");
                }
                if (strliYn3.equals("N")){
                    strliYn3 = "Y";
                    out.println("<li>");
                }
            }

			if (strRefMenuID.equalsIgnoreCase(strMenuID)) {
				if(blnMngUse) {
				} else {
					if("간사승인대기".equalsIgnoreCase(strMenuName)) {
						strMenuName = "접수완료";
					} else if ("간사승인완료".equalsIgnoreCase(strMenuName)) {
						System.out.println("");
					} else {
					}
				}
			} else {
				if(blnMngUse) {
				} else {
					if("간사승인대기".equalsIgnoreCase(strMenuName)) {
						strMenuName = "접수완료";
					} else if ("간사승인완료".equalsIgnoreCase(strMenuName)) {
						System.out.println("");
					} else {
					}
				}
			}
            stroldMenu = strOrderNum+strMenuDepth;
            String linkok = "ok";
            if (objMenuRs.next()) {
                String strMenuNameold = (String)objMenuRs.getObject("REQ_MENU_NM");
                String strRefIdold = (String)objMenuRs.getObject("REF_ID");
                 if (strMenuNameold.equals("간사승인완료")){
                    if (objMenuRs.next()) {
                    } else {
                        a="";
                    }
                }
                //국회의원 비전자요구 안보이게 하느라 삽질함...
                if (strRefIdold.equals("114")){
                    if (objMenuRs.next()) {
                    } else {
                        a="";
                    }
                }
                if (strRefIdold.equals("114")){
                    if (objMenuRs.next()) {
                    } else {
                        a="";
                    }
                }
                if (strRefIdold.equals("114")){
                    if (objMenuRs.next()) {
                    } else {
                        a="";
                    }
                }
                //요기까지
                String strMenuDepthold=(String)objMenuRs.getObject("MENU_DEPTH");
                if (Integer.parseInt(strMenuDepth)<Integer.parseInt(strMenuDepthold)){
                    linkok = "javascript:menuOpenFold('"+strOrderNum+strMenuDepth+"');";
                    strMenu = strOrderNum+strMenuDepth;
                } else {
                    linkok = strMenuPath+strMenuFileName+strMenuParam;
                }
            } else {
                linkok = strMenuPath+strMenuFileName+strMenuParam;
                a="";
            }
            //타이틀 넣기
            if("간사승인대기".equalsIgnoreCase(strMenuName)) {
                strMenuName = "접수완료";
            } else if ("간사승인완료".equalsIgnoreCase(strMenuName)) {
                System.out.println("");
            } else {
            }
            if (strMenuDepth.equals("1")){
                out.println("<h3><a href=\""+linkok+"\">"+strMenuName+"</a></h3>");
            } else if (strMenuDepth.equals("2")){
                out.println("<h4><a href=\""+linkok+"\">"+strMenuName+"</a></h4>");
            } else if (strMenuDepth.equals("3")){
                out.println("<h5><a href=\""+linkok+"\">-&nbsp;"+strMenuName+"</a></h5>");
            }

 		}
        if (strulYn3.equals("Y")){
            out.println("</li></ul>");
            strulYn3 = "N";
            strliYn3 = "N";
        }
        if (strulYn2.equals("Y")){
            out.println("</li></ul>");
            strulYn2 = "N";
            strliYn2 = "N";
        }
	} catch(kr.co.kcc.pf.exception.AppException e) {
		System.out.println("MENU Exception : " + e.getMessage());
		e.printStackTrace();
 	}
%>
</li>
</ul>
<p><img src="/images2/foundation/tl_bottom.gif" /></p>
</div>
