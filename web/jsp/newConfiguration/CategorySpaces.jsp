<%-- 
    Document   : CategorySpaces
    Created on : Sep 18, 2017, 9:16:11 PM
    Author     : aurea
--%>
<%
    String numberOfCategorizations = request.getParameter("numberOfCategorizations");
    Integer numCat = Integer.valueOf(numberOfCategorizations);
%>

<table style="width:  600px;text-align: center;">
    <%for (int i = 1; i <= numCat; i++) {%>
    <tr>
        <td style="width:  200px;text-align: right;">
            <b>Category Name <%=i%>:</b>
        </td>
        <td style="width:  400px;text-align: left;">
            <input style="width:  300px;" 
                   type="text" name="categoryName<%=i%>Input" 
                   id="categoryName<%=i%>Input" value=""><br>
        </td>
    </tr>
    <tr>
        <td style="width:  200px;text-align: right;">
            <b>Description Name <%=i%>:</b>
        </td>
        <td style="width:  400px;text-align: left;">
            <textarea style="width:  300px;" rows="4" cols="200" name="descriptionName<%=i%>Input" 
                      id="descriptionName<%=i%>Input">
            </textarea>
        </td>
    </tr>

    <tr>
        <td style="width:  200px;text-align: right;">
            <b># Classes <%=i%>:</b>
        </td>
        <td style="width:  400px;text-align: left;">
            <select name="numberClasses<%=i%>Input" 
                    id="numberClasses<%=i%>Input" style="width:170px;"
                    >
                <%for (int cl = 0; cl < 20; cl++) {%>
                <option value="<%=cl%>"><%=cl%></option>
                <%}%>
            </select>
        </td>
    </tr>
    <tr>
        <td style="width:  200px;text-align: right;">
            <b># Conditions <%=i%>:</b>
        </td>
        <td style="width:  400px;text-align: left;">
             <select name="numberConditions<%=i%>Input" 
                    id="numberConditions<%=i%>Input" style="width:170px;"
                    >
                <%for (int co = 0; co < 20; co++) {%>
                <option value="<%=co%>"><%=co%></option>
                <%}%>
            </select>
        </td>
    </tr>
    <tr>TODO conditions</tr>
    <tr>
        <td style="height:  30px;text-align: right;" colspan="2">
        </td>
    </tr>
    <%}%>
</table>
