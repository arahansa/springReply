package demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import demo.domain.Reply;

public interface ReplyRepository extends JpaRepository<Reply, Long>{
	@Modifying
	@Transactional
	@Query("update Reply r set r.comment = :comment where r.id= :id")
	public int updateReply(@Param("comment") String comment, @Param("id") Long id);
}
