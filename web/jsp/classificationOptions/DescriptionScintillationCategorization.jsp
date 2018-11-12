<%-- 
    Document   : DescriptionScintillationCategorization
    Created on : Mar 1, 2016, 6:48:58 PM
    Author     : aurea
--%>
<%@page import="categorization.Tiwari2011Sigma"%>
<%@page import="categorization.Hegarty2001Sigma"%>
<%@page import="categorization.ITUR2013S4"%>
<%@page import="categorization.Tiwari2011S4"%>
<%@page import="categorization.Hegarty2001S4"%>
<%
    String categorization = request.getParameter("categorization");
    String scintillationType = request.getParameter("scintillationType");
    String description = "";
    if (scintillationType != null && categorization != null && !categorization.equals("select") && !scintillationType.equals("select")) {
        if (scintillationType.equals("amplitude")) {

            if (categorization.equals("Hegarty2001-S4")) {
                description = (new Hegarty2001S4()).getDescription();
            } else {
                if (categorization.equals("Tiwari2011-S4")) {
                    description = (new Tiwari2011S4()).getDescription();
                } else {
                    if (categorization.equals("ITUR2013-S4")) {
                        description = (new ITUR2013S4()).getDescription();
                    } else {
                        description = "";
                    }
                }
            }

        } else {
            if (scintillationType.equals("phase")) {
                if (categorization.equals("Hegarty2001-Sigma")) {
                    description = (new Hegarty2001Sigma()).getDescription();
                } else {
                    if (categorization.equals("Tiwari2011-Sigma")) {
                        description = (new Tiwari2011Sigma()).getDescription();
                    } else {

                        description = "";
                    }
                }

            }
        }
    }
%>
<textarea rows="5" cols="35" name="descriptionCategorization"  id="descriptionCategorization" disabled style=" color: black;" >
    <%out.print(description);%>
</textarea>