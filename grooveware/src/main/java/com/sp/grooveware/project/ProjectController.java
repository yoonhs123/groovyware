package com.sp.grooveware.project;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller("project.ProjectController")
public class ProjectController {
	
	/*
	@RequestMapping(value = "/project", method=RequestMethod.GET)
	public String method() {
		return ".project.blank";
	}
	*/
	
	@RequestMapping("/project/blank")
	public String blank() {
		return ".project.blank";
	}
	
	@RequestMapping("/project/main")
	public String main() {
		return "project/main";
	}

}
