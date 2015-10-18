package demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import demo.domain.Reply;
import demo.repository.ReplyRepository;


@RestController
@RequestMapping("/comment")
public class RestReplyController {

	@Autowired ReplyRepository repoReply;
	
	// List
	@RequestMapping(method=RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	public List<Reply> replyList(){
		List<Reply> replies = repoReply.findAll();
		return replies;
	}
	
	// Create
	@RequestMapping(method=RequestMethod.POST)
	public ResponseEntity postReply(@RequestBody Reply reply){
		Reply createdReply = repoReply.save(reply);
		return new ResponseEntity<>(createdReply, HttpStatus.CREATED);
	}
	
	// Read
	@RequestMapping(value="/{id}", method=RequestMethod.GET)
	public Reply readOneReply(@PathVariable Long id){
		Reply reply = repoReply.findOne(id);
		return reply;
	}
	
	// Update
	@RequestMapping(value="/{id}", method=RequestMethod.PUT)
	public ResponseEntity<Reply> updateReply(@PathVariable Long id, @RequestBody Reply reply){
	    repoReply.updateReply(reply.getComment(), id);
	    return new ResponseEntity<>(reply, HttpStatus.OK);   
	}
	
	// Delete
	@RequestMapping(value="/{id}", method=RequestMethod.DELETE)
	public ResponseEntity deleteReply(@PathVariable Long id){
		repoReply.delete(id);
		return new ResponseEntity<>(HttpStatus.NO_CONTENT);
	}
}
