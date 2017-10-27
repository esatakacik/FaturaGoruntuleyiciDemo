package demo;

import java.io.IOException;
import java.io.InputStream;
import java.io.PushbackInputStream;

public class UnicodeXMLInputStream extends InputStream {
	PushbackInputStream internalIn;
	boolean isInited = false;
	String defaultEnc;
	String encoding;
	private static final int BOM_SIZE = 4;
	private static final int XMLREAD_SIZE = 256;

	public UnicodeXMLInputStream(InputStream in, String defaultEnc) {
		this.internalIn = new PushbackInputStream(in, 256);
		this.defaultEnc = defaultEnc;
	}

	public String getDefaultEncoding() {
		return this.defaultEnc;
	}

	public String getEncoding() {
		if (!this.isInited) {
			try {
				init();
			} catch (IOException ex) {
				throw new IllegalStateException("Init method failed.");
			}
		}
		return this.encoding;
	}

	protected synchronized void init() throws IOException {
		if (this.isInited) {
			return;
		}
		byte[] bom = new byte[4];

		int n = this.internalIn.read(bom, 0, bom.length);
		if ((bom[0] == -17) && (bom[1] == -69)) {
			if (bom[2] == -65) {
				this.encoding = "UTF-8";
				int unread = n - 3;
				// break label199;
			}
		}
		int unread;
		// int unread;
		if ((bom[0] == -2) && (bom[1] == -1)) {
			this.encoding = "UTF-16BE";
			unread = n - 2;
		} else {
			// int unread;
			if ((bom[0] == -1) && (bom[1] == -2)) {
				this.encoding = "UTF-16LE";
				unread = n - 2;
			} else {
				// int unread;
				if ((bom[0] == 0) && (bom[1] == 0) && (bom[2] == -2)
						&& (bom[3] == -1)) {
					this.encoding = "UTF-32BE";
					unread = n - 4;
				} else {
					// int unread;
					if ((bom[0] == -1) && (bom[1] == -2) && (bom[2] == 0)
							&& (bom[3] == 0)) {
						this.encoding = "UTF-32LE";
						unread = n - 4;
					} else {
						unread = n;
					}
				}
			}
		}
		// label199:
		if (unread > 0) {
			this.internalIn.unread(bom, n - unread, unread);
		}
		if (this.encoding == null) {
			this.encoding = getXMLEncoding();
		} else if (this.encoding.equals("")) {
			this.encoding = getXMLEncoding();
		}
		if (this.encoding == null) {
			this.encoding = this.defaultEnc;
		}
		this.isInited = true;
	}

	public synchronized void close() throws IOException {
		this.isInited = true;
		this.internalIn.close();
	}

	public synchronized int read() throws IOException {
		this.isInited = true;
		return this.internalIn.read();
	}

	private String getXMLEncoding() throws IOException {
		byte[] b = new byte[256];
		int readSize = this.internalIn.read(b);
		String s = new String(b);
		int start = s.indexOf("encoding");
		if (start == -1) {
			this.internalIn.unread(b, 0, readSize);
			return null;
		}
		int t = s.indexOf("\"", start);
		t = (t == -1) || (t > 15) ? s.indexOf("'", start) : t;
		start = t == -1 ? s.indexOf("'", start) : t;
		if (start == -1) {
			this.internalIn.unread(b, 0, readSize);
			return null;
		}
		int end = s.indexOf("\"", start + 1);
		end = (end == -1) || (end > 15) ? s.indexOf("'", start + 1) : end;
		if (end == -1) {
			end = s.indexOf("'", start + 1);
		}
		if (end == -1) {
			this.internalIn.unread(b, 0, readSize);
			return null;
		}
		if (start >= end) {
			this.internalIn.unread(b, 0, readSize);
			return null;
		}
		s = s.substring(start + 1, end);
		this.internalIn.unread(b, 0, readSize);
		return s;
	}
}
