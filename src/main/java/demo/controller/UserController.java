package demo.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import demo.domain.User;
import demo.dto.SocialDataInsertDTO;
import demo.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class UserController {

	
	@Autowired UserRepository userRepository;
	
	@RequestMapping(value = "/user")
	public String user(Model model) {
		return "user";
	}
	
	@RequestMapping(value="/loginPage")
	public String loginPage(){
		return "loginPage";
	}
	

	@RequestMapping(value="/user/login")
	public String login(User user, HttpSession session){
		log.debug("user :: {}", user);
		User loginedUser  = userRepository.findByNameAndPassword(user.getName(), user.getPassword());
		if(loginedUser != null){
			session.setAttribute("userSession", user);
		}
		return "redirect:/user";
	}
	
	@RequestMapping(value="/user/logout")
	public String logout(HttpSession session){
		session.setAttribute("userSession", null);
		return "redirect:/user"; 
	}

	@RequestMapping(value="/user/registerForm")
	public String registerForm(){
		return "userRegister";
	}
	
	@RequestMapping(value="/user/register")
	public String userRegister(User user, HttpSession session){
		userRepository.save(user);
		session.setAttribute("userSession", user);
		return "redirect:/user"; 
	}
	
	
	
	@RequestMapping(value="/updateSocialInfo")
	@ResponseBody
	public String updateSocialInfo(SocialDataInsertDTO socialDataInsertDTO){
		log.debug("SocialDataInsertDTO :: {}" , socialDataInsertDTO);
		User user  = userRepository.findOne(socialDataInsertDTO.getUserId());
		switch (socialDataInsertDTO.getSocialType()) {
			case "facebook": user.setFaceId(socialDataInsertDTO.getSocialId());break;
			case "twitter" : user.setTwitId(socialDataInsertDTO.getSocialId());break;
			case "kakao" : user.setKakaoId(socialDataInsertDTO.getSocialId()); break;
		}
		return "success";
	}
}
