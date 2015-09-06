package demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import demo.domain.Reply;
import demo.repository.ReplyRepository;


@RestController
@RequestMapping("/comment")
public class RestReplyController {

	@Autowired ReplyRepository repoReply;
	
	// List
	@RequestMapping(method=RequestMethod.GET)
	public List<Reply> replyList(){
		List<Reply> replies = repoReply.findAll();
		return replies;
	}
	
	// Create
	@RequestMapping(method=RequestMethod.POST, headers={"Content-type=application/json"})
	public Reply postReply(@RequestBody Reply reply){
		repoReply.save(reply);
		System.out.println(reply);
		return reply;
	}
	
	// Read
	@RequestMapping(value="/{id}", method=RequestMethod.GET)
	public Reply readOneReply(@PathVariable Long id){
		Reply reply = repoReply.findOne(id);
		return reply;
	}
	
	// Update
	@RequestMapping(value="/{id}", method=RequestMethod.PUT, headers={"Content-type=application/json"})
	public Reply updateReply(@PathVariable Long id, @RequestBody Reply reply){
		repoReply.updateReply(reply.getComment(), id);
		return reply;
	}
	
	// Delete
	@RequestMapping(value="/{id}", method=RequestMethod.DELETE)
	public String deleteReply(@PathVariable Long id){
		repoReply.delete(id);
		return "DELETE";
	}
	

	
}
