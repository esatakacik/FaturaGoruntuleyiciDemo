package demo;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Base64;
import java.util.HashMap;
import java.util.UUID;

import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.SAXNotRecognizedException;
import org.xml.sax.SAXNotSupportedException;
import org.xml.sax.SAXParseException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.helpers.XMLReaderFactory;

public class DocParser extends DefaultHandler {
	private String base64Attachment = "";
	private String docID = "";
	private String base64Signature = "";
	private String actualSignaturePath = "";
	private HashMap<String, String> edboAttributes = new HashMap();
	private String baseDir = "";
	public StringBuffer cKey = new StringBuffer().append("BT");
	private boolean valid = true;
	StringBuilder content = new StringBuilder(64);
	private Exception invoiceException = null;
	private String docType = null;
	private String docSignRef = null;
	private String docSignVal = null;
	private String docUblVersionId = null;
	private String docIssueDate = null;
	private String docIssueTime = null;

	public String getDocType() {
		return this.docType;
	}

	public DocParser(String baseDir, InputStream xmlFileis,
			CSEntityResolver cser, boolean schema, boolean validate,
			String encoding) {
		this.baseDir = baseDir;
		try {
			XMLReader r = XMLReaderFactory.createXMLReader();
			if (schema) {
				r.setEntityResolver(cser);
			}
			r.setFeature("http://xml.org/sax/features/validation", validate);
			r.setFeature("http://apache.org/xml/features/validation/schema",
					schema);
			r.setErrorHandler(this);
			r.setContentHandler(this);
			InputStreamReader isr = new InputStreamReader(xmlFileis, encoding);

			InputSource is = new InputSource(isr);
			this.valid = true;
			r.parse(is);
		} catch (FileNotFoundException e) {
			this.valid = false;
			this.invoiceException = e;
		} catch (SAXNotRecognizedException e) {
			this.valid = false;
			this.invoiceException = e;
		} catch (SAXNotSupportedException e) {
			this.valid = false;
			this.invoiceException = e;
		} catch (SAXException e) {
			this.valid = false;
			this.invoiceException = e;
		} catch (UnsupportedEncodingException e) {
			this.valid = false;
			this.invoiceException = e;
		} catch (IOException e) {
			this.valid = false;
			this.invoiceException = e;
		} catch (Exception e) {
			this.valid = false;
			this.invoiceException = e;
		}
	}

	public void startElement(String uri, String local, String arg2,
			Attributes att) throws SAXException {
		this.content.setLength(0);
		this.cKey.append(".");
		this.cKey.append(local);
		if ((this.cKey.toString()
				.startsWith("BT.Invoice.AdditionalDocumentReference.Attachment.EmbeddedDocumentBinaryObject"))
				|| (this.cKey.toString()
						.startsWith("BT.ApplicationResponse.DocumentResponse.DocumentReference.Attachment.EmbeddedDocumentBinaryObject"))) {
			for (int i = 0; i < att.getLength(); i++) {
				this.edboAttributes.put(att.getLocalName(i).toLowerCase(),
						att.getValue(i));
			}
		}
	}

	@Override
    public void endElement(final String uri, final String name, final String qName) throws SAXException {
        if (this.cKey.toString().startsWith("BT.Invoice.ID") || this.cKey.toString().startsWith("BT.ApplicationResponse.ID")) {
            this.setDocID(this.content.toString());
            this.docType = this.cKey.toString().split("\\.")[1];
        }
        else if (this.cKey.toString().startsWith("BT.Invoice.AdditionalDocumentReference.Attachment.EmbeddedDocumentBinaryObject") || this.cKey.toString().startsWith("BT.ApplicationResponse.DocumentResponse.DocumentReference.Attachment.EmbeddedDocumentBinaryObject")) {
            if ((this.edboAttributes.containsKey("filename") || (this.edboAttributes.containsKey("mimecode") && this.edboAttributes.get("mimecode").toString().equalsIgnoreCase("application/xml"))) && this.edboAttributes.containsKey("encodingcode") && this.edboAttributes.get("encodingcode").toString().equalsIgnoreCase("Base64")) {
                if (!this.edboAttributes.containsKey("filename")) {
                    this.edboAttributes.put("filename", UUID.randomUUID() + ".xslt");
                }
                this.setBase64Attachment(this.content.toString());
                FileOutputStream fos = null;
                try {
                    //final Path p = Paths.get(this.edboAttributes.get("filename"), new String[0]);
                    //final String fileName = p.getFileName().toString();
                	final String fileName = this.edboAttributes.get("filename");
                    fos = new FileOutputStream(new File(String.valueOf(this.baseDir) + fileName));
                    final byte[] b = Base64.getDecoder().decode(this.getBase64Attachment());
                    if (b != null) {
                        fos.write(b);
                    }
                    fos.flush();
                }
                catch (Exception e) {
                    e.printStackTrace();
                }
                finally {
                    try {
                        fos.close();
                    }
                    catch (IOException ex) {}
                }
                try {
                    fos.close();
                }
                catch (IOException ex2) {}
            }
        }
        else if (this.cKey.toString().startsWith("BT.berat.xbrl.accountingEntries.documentInfo.uniqueID")) {
            this.setDocID(this.content.toString());
            this.docType = this.cKey.toString().split("\\.")[2];
        }
        else if (this.cKey.toString().startsWith("BT.berat.SignatureValue")) {
            this.docSignRef = this.content.toString().replaceAll("\\s+", "");
        }
        else if (this.cKey.toString().startsWith("BT.defter.Signature.SignatureValue")) {
            this.docSignVal = this.content.toString().replaceAll("\\s+", "");
        }
        else if (this.cKey.toString().startsWith("BT.Invoice.UBLVersionID") || this.cKey.toString().startsWith("BT.ApplicationResponse.UBLVersionID")) {
            this.setDocUblVersionId(this.content.toString());
        }
        else if (this.cKey.toString().startsWith("BT.Invoice.IssueDate")) {
            this.setDocIssueDate(this.content.toString());
        }
        else if (this.cKey.toString().startsWith("BT.Invoice.IssueTime")) {
            this.setDocIssueTime(this.content.toString());
        }
        this.cKey.delete(this.cKey.lastIndexOf("."), this.cKey.length());
    }

	public void characters(char[] text, int start, int length) {
		this.content.append(new String(text, start, length));
	}

	public void error(SAXParseException e) throws SAXException {
		throw e;
	}

	public boolean isValid() {
		return this.valid;
	}

	public Exception getInvoiceException() {
		return this.invoiceException;
	}

	public void setInvoiceException(Exception envelopeException) {
		this.invoiceException = envelopeException;
	}

	public void setValid(boolean valid) {
		this.valid = valid;
	}

	public String getBase64Attachment() {
		return this.base64Attachment;
	}

	public void setBase64Attachment(String base64Xslt) {
		this.base64Attachment = base64Xslt;
	}

	public String getBase64Signature() {
		return this.base64Signature;
	}

	public void setBase64Signature(String base64Signature) {
		this.base64Signature = base64Signature;
	}

	public String getInvoiceID() {
		return this.docID;
	}

	public void setDocID(String invoiceID) {
		this.docID = invoiceID;
	}

	public String getBaseDir() {
		return this.baseDir;
	}

	public void setBaseDir(String baseDir) {
		this.baseDir = baseDir;
	}

	public String getActualSignaturePath() {
		return this.actualSignaturePath;
	}

	public void setActualSignaturePath(String actualSignaturePath) {
		this.actualSignaturePath = actualSignaturePath;
	}

	public String getDocSignRef() {
		return this.docSignRef;
	}

	public String getDocSignVal() {
		return this.docSignVal;
	}

	public String getDocUblVersionId() {
		return this.docUblVersionId;
	}

	public void setDocUblVersionId(String docUblVersionId) {
		this.docUblVersionId = docUblVersionId;
	}

	public String getDocIssueDate() {
		return this.docIssueDate;
	}

	public void setDocIssueDate(String docIssueDate) {
		this.docIssueDate = docIssueDate;
	}

	public String getDocIssueTime() {
		return this.docIssueTime;
	}

	public void setDocIssueTime(String docIssueTime) {
		this.docIssueTime = docIssueTime;
	}
}
