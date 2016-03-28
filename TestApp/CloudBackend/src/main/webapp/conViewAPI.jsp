<%@ page import="java.util.*" %>
<%@ page import="javax.jdo.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="edu.oregonstate.backend.*" %>

<%@ page trimDirectiveWhitespaces="true" %>

<%
	PersistenceManager pm = PMF.getPMF().getPersistenceManager();
	try {
		Query query = pm.newQuery(Contact.class);
		Contact cont = new Contact();
		
        String state = request.getParameter("state");
    
        List<Contact> contacts = cont.loadContacts(null, pm);
       
        if(state == "ALL"){
           query = pm.newQuery(Contact.class);
           contacts = (List<Contact>)query.execute();
        } else {
           query = pm.newQuery(Contact.class, "state == :ss");
            contacts = (List<Contact>)query.execute(state);
        }
		
		JSONArray array = new JSONArray();
		for (Contact obj : contacts) {
			JSONObject object = new JSONObject();
			object.put("contactId", obj.getID());
			object.put("address", obj.getAddress());
			object.put("city", obj.getCity());
			object.put("state", obj.getState());
			object.put("email", obj.getEmail());
			object.put("phoneNum", obj.getPhoneNum());
			array.add(object);
		}
		out.write(array.toString());
		query.closeAll();
	} finally {
		pm.close();
	}
%>