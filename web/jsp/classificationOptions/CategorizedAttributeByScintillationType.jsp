<%-- 
    Document   : CategorizedAttributeByScintillationType
    Created on : Mar 1, 2016, 6:34:12 PM
    Author     : aurea
--%>


<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.ArrayList"%>
<%
    String scintillationType = request.getParameter("scintillationType");
    if (scintillationType != null) {
        String nameCategory = null;
        ArrayList<String> listCategorizedAttributesByScintillationType = new ArrayList<String>();

        String driver = (String) session.getAttribute("driver");
        String url = (String) session.getAttribute("url");
        String username = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

        if (scintillationType.equals("amplitude")) {
            nameCategory = "s4_index";

        } else {
            if (scintillationType.equals("phase")) {
                nameCategory = "sigmaphi_index";
            }
        }
        if (nameCategory != null) {
            try {
                /* get all attributes*/
                String scintillationAttributeName = null;;

                String queryAttributesByCategory = "select * from getAttributesByCategory('" + nameCategory + "');";
                Connection connection = null;
                PreparedStatement preparedStatement = null;
                ResultSet resultAttributesByCategorySet = null;
                Class.forName(driver).newInstance();
                connection = DriverManager.getConnection(url, username, password);
                preparedStatement = connection.prepareStatement(queryAttributesByCategory);
                resultAttributesByCategorySet = preparedStatement.executeQuery();

                while (resultAttributesByCategorySet.next()) {
                    scintillationAttributeName = resultAttributesByCategorySet.getString("scintillation_attribute_name");
                    //if ((typeField.equals("numeric") || typeField.equals("integer")) && !dataField.equals("station_id") && !dataField.equals("svid") && !dataField.equals("observation_id") ) {
                    listCategorizedAttributesByScintillationType.add(scintillationAttributeName);
                    //}

                }
resultAttributesByCategorySet.close();
            preparedStatement.close();
                connection.close();

            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            } catch (SQLException ex) {
                out.print("SQLException: " + ex.getMessage());
                out.print("SQLState: " + ex.getSQLState());
                out.print("VendorError: " + ex.getErrorCode());
            }
        }
%>
<select name="selectCategorizedAttributeByScintillationType" id="selectCategorizedAttributeByScintillationType"   style="width: 120px" onchange="clearMessage()" >
    <option value="select">Select...</option>
    <%for (int i = 0; i < listCategorizedAttributesByScintillationType.size(); i++) {%>
    <option value="<%out.print(listCategorizedAttributesByScintillationType.get(i));%>"><%out.print(listCategorizedAttributesByScintillationType.get(i));%></option>
    <%}%>
</select>
<%} else {%>
<select name="selectCategorizedAttributeByScintillationType" id="selectCategorizedAttributeByScintillationType"   style="width: 120px"  onchange="clearMessage()">
    <option value="select">Select...</option>

</select>
<%}%>