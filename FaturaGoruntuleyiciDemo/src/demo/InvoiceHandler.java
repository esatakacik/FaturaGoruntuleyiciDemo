package demo;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Locale;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

public class InvoiceHandler
  extends DefaultHandler
{
  Invoice inv = new Invoice();
  StringBuilder content = new StringBuilder(64);
  public StringBuffer cKey = new StringBuffer().append("BT");
  private HashMap<String, String> edboAttributes = new HashMap();
  
  public void startElement(String uri, String local, String arg2, Attributes att)
    throws SAXException
  {
    this.content.setLength(0);
    this.cKey.append(".");
    this.cKey.append(local);
    if (this.cKey.toString().startsWith("BT.Invoice.UBLExtensions.UBLExtension.ExtensionContent.Signature.SignedInfo.Reference")) {
      for (int i = 0; i < att.getLength(); i++) {
        this.edboAttributes.put(att.getLocalName(i).toLowerCase(Locale.ENGLISH), att.getValue(i));
      }
    } else if (this.cKey.toString().startsWith("BT.Invoice.AccountingSupplierParty.Party.PartyIdentification.ID")) {
      for (int i = 0; i < att.getLength(); i++) {
        this.edboAttributes.put(att.getLocalName(i).toLowerCase(Locale.ENGLISH), att.getValue(i));
      }
    } else if (this.cKey.toString().startsWith("BT.Invoice.AccountingCustomerParty.Party.PartyIdentification.ID")) {
      for (int i = 0; i < att.getLength(); i++) {
        this.edboAttributes.put(att.getLocalName(i).toLowerCase(Locale.ENGLISH), att.getValue(i));
      }
    }
  }
  
  public void endElement(String uri, String name, String qName)
    throws SAXException
  {
    if (this.cKey.toString().startsWith("BT.Invoice.UBLExtensions.UBLExtension.ExtensionContent.Signature.SignedInfo.Reference"))
    {
      if ((this.cKey.toString().startsWith("BT.Invoice.UBLExtensions.UBLExtension.ExtensionContent.Signature.SignedInfo.Reference.DigestValue")) && 
        (this.edboAttributes.containsKey("uri")) && 
        (((String)this.edboAttributes.get("uri")).equals(""))) {
        try
        {
          this.inv.setDigestValue(URLEncoder.encode(this.content.toString(), "UTF-8"));
        }
        catch (UnsupportedEncodingException e)
        {
          e.printStackTrace();
        }
      }
    }
    else if (this.cKey.toString().startsWith("BT.Invoice.ID")) {
      this.inv.setInvoiceId(this.content.toString());
    } else if (this.cKey.toString().startsWith("BT.Invoice.LegalMonetaryTotal.PayableAmount")) {
      this.inv.setOdenecekTutar(this.content.toString());
    } else if (this.cKey.toString().startsWith("BT.Invoice.AccountingSupplierParty.Party.PartyIdentification.ID"))
    {
      if (this.edboAttributes.containsKey("schemeid"))
      {
        String vkn = (String)this.edboAttributes.get("schemeid");
        if ((vkn.contains("VKN")) || (vkn.contains("TCKN"))) {
          this.inv.setSaticiVknTckn(this.content.toString());
        }
      }
    }
    else if (this.cKey.toString().startsWith("BT.Invoice.ProfileID")) {
      this.inv.setProfileId(this.content.toString());
    } else if (this.cKey.toString().startsWith("BT.Invoice.AccountingCustomerParty.Party.PartyIdentification.ID"))
    {
      if (this.edboAttributes.containsKey("schemeid"))
      {
        String vkn = (String)this.edboAttributes.get("schemeid");
        if ((vkn.contains("VKN")) || (vkn.contains("TCKN"))) {
          this.inv.setAliciVknTckn(this.content.toString());
        }
      }
    }
    else if (this.cKey.toString().startsWith("BT.Invoice.LegalMonetaryTotal.LineExtensionAmount")) {
      this.inv.setToplamTutar(this.content.toString());
    } else if (this.cKey.toString().startsWith("BT.Invoice.IssueDate")) {
      this.inv.setFaturaDuzTarih(this.content.toString());
    }
    this.cKey.delete(this.cKey.lastIndexOf("."), this.cKey.length());
  }
  
  public void characters(char[] text, int start, int length)
  {
    this.content.append(new String(text, start, length));
  }
  
  public Invoice getInvoice()
  {
    return this.inv;
  }
}

