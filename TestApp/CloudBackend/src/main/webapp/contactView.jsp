<%@ page import="javax.jdo.*" %>
<%@ page import="edu.oregonstate.backend.*" %>

<%@ page trimDirectiveWhitespaces="true" %>

<%
	PersistenceManager pm = PMF.getPMF().getPersistenceManager();
	try {
		String contactId = request.getParameter("contact");
		
		Contact contact = (Contact)pm.getObjectById(Contact.class, Long.parseLong(contactId));
		
		String name = contact.getContactName();
		String address = contact.getAddress();
		String city = contact.getCity();
		String state = contact.getState();
		String email = contact.getEmail();
		String phone = contact.getPhoneNum();
		
		//Photo
		byte[] photo = contact.getPhoto();
		response.setContentType("image/jpeg");
		response.getOutputStream().write(photo);
	} catch (Exception cannotLoad) {	
	} finally {
		pm.close();
	}
%>