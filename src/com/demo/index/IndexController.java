package com.demo.index;

import com.jfinal.core.Controller;

/**
 * IndexController
 */
public class IndexController extends Controller {
	public void index() {
		setAttr("msg", "this is a message from java!");
		render("index.jsp");
	}
}





