package demo;

import tr.com.cs.signer.util.*;
import java.security.*;
import tr.com.cs.signer.cert.*;
import java.io.*;
import javax.xml.validation.*;
import org.xml.sax.*;
import javax.xml.parsers.*;
import org.w3c.dom.*;
import javax.xml.transform.stream.*;
import javax.xml.transform.*;
import tr.com.cs.signer.xml.*;
import java.util.*;

public class Doc
{
    public static String defaultIXsltPath;
    public static String defaultAPRXsltPath;
    public static String defaultXBRLXsltPath;
    private String docType;
    private String docUblVersion;
    private String docIssueDate;
    private String docIssueTime;
    static C_Pair<C_Certificate, PrivateKey> ckPair;
    static KeyStore keyStore;
    public static String saxonHata;
    DocParser docParser;
    String htmlPath;
    String baseDir;
    String xmlPath;
    String actualSignaturePath;
    boolean defaultXslt;
    protected static File gorunteliyiciHome;
    
    static {
        Doc.defaultIXsltPath = null;
        Doc.defaultAPRXsltPath = null;
        Doc.defaultXBRLXsltPath = null;
        Doc.ckPair = null;
        Doc.saxonHata = "";
    }
    
    public Doc(final String xmlPath, final boolean isDefaultXslt) throws Exception {
        this.docType = null;
        this.docUblVersion = null;
        this.docIssueDate = null;
        this.docIssueTime = null;
        this.docParser = null;
        this.htmlPath = null;
        this.baseDir = "";
        this.xmlPath = "";
        this.actualSignaturePath = "";
        this.defaultXslt = false;
        this.xmlPath = xmlPath;
        Doc.saxonHata = "";
        this.baseDir = gorunteliyiciHome + File.separator + UUID.randomUUID().toString() + File.separator;
        System.out.println(this.baseDir);
        final File baseDirFile = new File(this.baseDir);
        baseDirFile.mkdirs();
        try {
            this.xmlParse();
        }
        catch (IOException e) {
            e.printStackTrace();
        }
        if (!this.docParser.isValid()) {
            throw this.docParser.getInvoiceException();
        }
        this.htmlPath = String.valueOf(this.baseDir) + this.docParser.getInvoiceID().replace(" ", "").trim() + ".html";
        this.htmlPath = this.htmlPath.replaceAll(" ", "%20");
        this.actualSignaturePath = this.docParser.getActualSignaturePath();
        this.docType = this.docParser.getDocType();
        this.docUblVersion = this.docParser.getDocUblVersionId();
        this.docIssueDate = this.docParser.getDocIssueDate();
        this.docIssueTime = this.docParser.getDocIssueTime();
        this.generateHTML(isDefaultXslt);
    }
    
    private static void sertifikaAl() {
        try {
            if (Doc.ckPair == null) {
                Doc.ckPair = (C_Pair<C_Certificate, PrivateKey>)new C_Pair();
                Doc.keyStore = C_KeyStore.getCertAndKey((C_Pair)Doc.ckPair);
            }
        }
        catch (Exception e1) {
            System.err.println("E-imza kartina erisim sirasinda hata olustu, l\ufffdtfen tekrar deneyiniz.");
            e1.printStackTrace();
        }
    }
    
    public void xmlParse() throws IOException {
        final CSEntityResolver cser = new CSEntityResolver();
        final UnicodeXMLInputStream xmlFileIS = new UnicodeXMLInputStream(new BufferedInputStream(new FileInputStream(this.xmlPath)), "UTF-8");
        this.docParser = new DocParser(this.baseDir, xmlFileIS, cser, false, false, xmlFileIS.getEncoding());
        xmlFileIS.close();
        if (!this.docParser.isValid()) {
            final Exception e = this.docParser.getInvoiceException();
            e.printStackTrace();
        }
    }
    
    
    public Invoice getCurrentInvoice() throws ParserConfigurationException, IOException, SAXException {
        final SAXParserFactory factory = SAXParserFactory.newInstance();
        factory.setValidating(false);
        factory.setNamespaceAware(true);
        final SchemaFactory schemaFactory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
        SAXParser parser = null;
        if ("Invoice".equals(this.docType)) {
            File invSchemaFile = null;
            if ("2.0".equals(this.docUblVersion)) {
                invSchemaFile = new File(String.valueOf(System.getProperty("java.io.tmpdir")) + File.separator + "EFaturaGoruntuleyici" + "/schema/1.0/maindoc/" + "UBLTR-Invoice-2.0.xsd");
            }
            else if ("2.1".equals(this.docUblVersion)) {
                invSchemaFile = new File(String.valueOf(System.getProperty("java.io.tmpdir")) + File.separator + "EFaturaGoruntuleyici" + "/schema/1.2/maindoc/" + "UBL-Invoice-2.1.xsd");
            }
            factory.setSchema(schemaFactory.newSchema(invSchemaFile));
        }
        else if ("ApplicationResponse".equals(this.docType)) {
            File aprSchemaFile = null;
            if ("2.0".equals(this.docUblVersion)) {
                aprSchemaFile = new File(String.valueOf(System.getProperty("java.io.tmpdir")) + File.separator + "EFaturaGoruntuleyici" + "/schema/1.0/maindoc/" + "UBLTR-ApplicationResponse-2.0.xsd");
            }
            else if ("2.1".equals(this.docUblVersion)) {
                aprSchemaFile = new File(String.valueOf(System.getProperty("java.io.tmpdir")) + File.separator + "EFaturaGoruntuleyici" + "/schema/1.2/maindoc/" + "UBL-ApplicationResponse-2.1.xsd");
            }
            factory.setSchema(schemaFactory.newSchema(aprSchemaFile));
        }
        parser = factory.newSAXParser();
        final XMLReader reader = parser.getXMLReader();
        final InvoiceHandler invoiceHandler = new InvoiceHandler();
        reader.setContentHandler(invoiceHandler);
        /*reader.setErrorHandler(new ErrorHandler() {
            @Override
            public void warning(final SAXParseException e) throws SAXException {
            }
            
            @Override
            public void error(final SAXParseException e) throws SAXException {
                throw e;
            }
            
            @Override
            public void fatalError(final SAXParseException e) throws SAXException {
                throw e;
            }
        });
        reader.parse(new InputSource(new File(this.xmlPath).toURI().toURL().toString()));*/
        return invoiceHandler.getInvoice();
    }
    
    public boolean validateWithExtXSDUsingSAX() throws ParserConfigurationException, IOException, SAXException {
        final SAXParserFactory factory = SAXParserFactory.newInstance();
        factory.setValidating(false);
        factory.setNamespaceAware(true);
        final SchemaFactory schemaFactory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
        SAXParser parser = null;
        if ("2.0".equals(this.docUblVersion)) {
            if ("Invoice".equals(this.docType)) {
                final File invSchemaFile = new File(String.valueOf(System.getProperty("java.io.tmpdir")) + File.separator + "EFaturaGoruntuleyici" + "/schema/1.0/maindoc/" + "UBLTR-Invoice-2.0.xsd");
                factory.setSchema(schemaFactory.newSchema(invSchemaFile));
            }
            else if ("ApplicationResponse".equals(this.docType)) {
                final File aprSchemaFile = new File(String.valueOf(System.getProperty("java.io.tmpdir")) + File.separator + "EFaturaGoruntuleyici" + "/schema/1.0/maindoc/" + "UBLTR-ApplicationResponse-2.0.xsd");
                factory.setSchema(schemaFactory.newSchema(aprSchemaFile));
            }
            else if ("xbrl".equals(this.docType)) {
                return true;
            }
        }
        else if ("2.1".equals(this.docUblVersion)) {
            if ("Invoice".equals(this.docType)) {
                final File invSchemaFile = new File(String.valueOf(System.getProperty("java.io.tmpdir")) + File.separator + "EFaturaGoruntuleyici" + "/schema/1.2/maindoc/" + "UBL-Invoice-2.1.xsd");
                factory.setSchema(schemaFactory.newSchema(invSchemaFile));
            }
            else if ("ApplicationResponse".equals(this.docType)) {
                final File aprSchemaFile = new File(String.valueOf(System.getProperty("java.io.tmpdir")) + File.separator + "EFaturaGoruntuleyici" + "/schema/1.2/maindoc/" + "UBL-ApplicationResponse-2.1.xsd");
                factory.setSchema(schemaFactory.newSchema(aprSchemaFile));
            }
            else if ("xbrl".equals(this.docType)) {
                return true;
            }
        }
        parser = factory.newSAXParser();
        final XMLReader reader = parser.getXMLReader();
        /*reader.setErrorHandler(new ErrorHandler() {
            @Override
            public void warning(final SAXParseException e) throws SAXException {
            }
            
            @Override
            public void error(final SAXParseException e) throws SAXException {
                throw e;
            }
            
            @Override
            public void fatalError(final SAXParseException e) throws SAXException {
                throw e;
            }
        });
        reader.parse(new InputSource(new File(this.xmlPath).toURI().toURL().toString()));*/
        return true;
    }
    
    public void generateHTML(final boolean isDefaultXslt) throws Exception {
        final File tempFile = new File(this.baseDir);
        final File[] fileList = tempFile.listFiles();
        String xsltPath = "";
        for (int i = 0; i < fileList.length; ++i) {
            final String fName = fileList[i].getName().toUpperCase();
            if (fName.endsWith(".XSLT") || fName.endsWith(".XSL")) {
                xsltPath = fileList[i].getAbsolutePath().replaceAll(" ", "%20");
                break;
            }
        }
        if ("Invoice".equals(this.docType) && isDefaultXslt) {
            this.defaultXslt = false;
            this.transform(this.xmlPath, Doc.defaultIXsltPath, this.htmlPath);
        }
        else if ("ApplicationResponse".equals(this.docType) && isDefaultXslt) {
            this.defaultXslt = false;
            this.transform(this.xmlPath, Doc.defaultAPRXsltPath, this.htmlPath);
        }
        else if ("xbrl".equals(this.docType) && isDefaultXslt) {
            this.defaultXslt = false;
            this.transform(this.xmlPath, Doc.defaultXBRLXsltPath, this.htmlPath);
        }
        else if (!"".equals(xsltPath)) {
            this.defaultXslt = false;
            this.transform(this.xmlPath, xsltPath, this.htmlPath);
        }
        else if ("Invoice".equals(this.docType)) {
            this.defaultXslt = true;
            this.transform(this.xmlPath, Doc.defaultIXsltPath, this.htmlPath);
        }
        else if ("ApplicationResponse".equals(this.docType)) {
            this.defaultXslt = true;
            this.transform(this.xmlPath, Doc.defaultAPRXsltPath, this.htmlPath);
        }
        else if ("xbrl".equals(this.docType)) {
            this.defaultXslt = true;
            this.transform(this.xmlPath, Doc.defaultXBRLXsltPath, this.htmlPath);
        }
    }
    
    private static Element createElement(final Document doc, final String tag, final String prefix, final String nsURI) {
        final String qName = (prefix == null) ? tag : (String.valueOf(prefix) + ":" + tag);
        return doc.createElementNS(nsURI, qName);
    }
    
    public void transform(String inXML, String inXSL, String outTXT) throws TransformerConfigurationException, TransformerException {
        if (Common.isOSWindows()) {
            inXML = "file:/" + inXML.replaceAll("\\\\", "/");
            outTXT = "file:/" + outTXT.replaceAll("\\\\", "/");
        }
        inXSL = inXSL.replaceAll("\\\\", "/");
        final TransformerFactory factory = TransformerFactory.newInstance();
        final StreamSource xslStream = new StreamSource(inXSL);
        xslStream.setSystemId(inXSL);
        factory.setErrorListener(new MyErrorListener(Doc.saxonHata));
        final Transformer transformer = factory.newTransformer(xslStream);
        final Properties pr = transformer.getOutputProperties();
        transformer.setErrorListener(new MyErrorListener(Doc.saxonHata));
        final StreamSource in = new StreamSource(inXML);
        in.setSystemId(inXML);
        final StreamResult out = new StreamResult(outTXT);
        transformer.transform(in, out);
    }
    
    public boolean validateSignature() throws Exception {
        boolean retVal = true;
        final List<C_XMLValidateInfo> valInfs = (List<C_XMLValidateInfo>)C_XMLValidater.validate((InputStream)new FileInputStream(this.xmlPath));
        for (final C_XMLValidateInfo valInf : valInfs) {
            retVal = (retVal && valInf.getStatus() == SignPropsConstants.XMLSignValidationType.VALID);
        }
        return retVal;
    }
    
    public boolean sdoc() throws Exception {
        return true;
    }
    
    /*public String validateSchematron() {
        return SignValidation.schematronControl(this.xmlPath, this.docUblVersion);
    }
    
    public C_Certificate getCertificate() throws Exception {
        return SignValidation.getSignCert(this.xmlPath);
    }
    
    public String getSignTime() throws Exception {
        return SignValidation.getSignTime(this.xmlPath);
    }*/
    
    public String getBaseDir() {
        return this.baseDir;
    }
    
    public void setBaseDir(final String baseDir) {
        this.baseDir = baseDir;
    }
    
    public String getHtmlPath() {
        if (this.htmlPath.startsWith("/")) {
            return "file://" + this.htmlPath;
        }
        return "file:///" + this.htmlPath;
    }
    
    public void setHtmlPath(final String htmlPath) {
        this.htmlPath = htmlPath;
    }
    
    public DocParser getDocParser() {
        return this.docParser;
    }
    
    public void setDocParser(final DocParser invoiceParser) {
        this.docParser = invoiceParser;
    }
    
    public String getXmlPath() {
        return this.xmlPath;
    }
    
    public void setXmlPath(final String xmlPath) {
        this.xmlPath = xmlPath;
    }
    
    public static String getDefaultIXsltPath() {
        return Doc.defaultIXsltPath;
    }
    
    public static void setDefaultIXsltPath(final String defaultXsltPath) {
        Doc.defaultIXsltPath = defaultXsltPath;
    }
    
    public static String getDefaultAPRXsltPath() {
        return Doc.defaultAPRXsltPath;
    }
    
    public static void setDefaultAPRXsltPath(final String defaultAPRXsltPath) {
        Doc.defaultAPRXsltPath = defaultAPRXsltPath;
    }
    
    public static void setDefaultXBRLXsltPath(final String defaultXBRLXsltPath) {
        Doc.defaultXBRLXsltPath = defaultXBRLXsltPath;
    }
    
    public boolean isDefaultXslt() {
        return this.defaultXslt;
    }
    
    public void setDefaultXslt(final boolean defaultXslt) {
        this.defaultXslt = defaultXslt;
    }
    
    public String getActualSignaturePath() {
        return this.actualSignaturePath;
    }
    
    public void setActualSignaturePath(final String actualSignaturePath) {
        this.actualSignaturePath = actualSignaturePath;
    }
    
    public String getDocIssueDate() {
        return this.docIssueDate;
    }
    
    public void setDocIssueDate(final String docIssueDate) {
        this.docIssueDate = docIssueDate;
    }
    
    public String getDocIssueTime() {
        return this.docIssueTime;
    }
    
    public void setDocIssueTime(final String docIssueTime) {
        this.docIssueTime = docIssueTime;
    }
    
    public static void main(final String[] args) {
    	init();
        try {
            final Doc doc = new Doc("C:\\Users\\esat\\Downloads\\efatura goruntuleyici jars\\DMR2017000000225.xml", false);
            System.out.println("basarili");
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        
    }
    public static void init() {
		String userTemp = System.getProperty("java.io.tmpdir");
		String userTempGoruntuleyici = userTemp + File.separator
				+ "EFaturaGoruntuleyici";
		FileUtil.makeLocalDirectory(userTempGoruntuleyici);
		gorunteliyiciHome = new File(userTempGoruntuleyici);
		// loadSchemas(userTempGoruntuleyici);

		System.setProperty("javax.xml.transform.TransformerFactory",
				"net.sf.saxon.TransformerFactoryImpl");
	}
}
