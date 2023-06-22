package com.sp.grooveware.approval;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.sp.grooveware.common.FileManager;
import com.sp.grooveware.common.dao.CommonDAO;

@Service("approval.approvalService")
public class ApprovalServiceImpl implements ApprovalService {

	@Autowired
	private CommonDAO dao;
	
	@Autowired
	private FileManager fileManager;
	

	@Override
	public void insertApproval(Approval dto, String pathname) throws Exception {
		try {
			long seq = dao.selectOne("approval.seq");
			dto.setDoc_no(seq);
			
			dao.insertData("approval.insertApproval1", dto);
			dao.insertData("approval.insertApproval2", dto);
			
			if (! dto.getSelectFile().isEmpty()) {
				for (MultipartFile mf : dto.getSelectFile()) {
					String saveFilename = fileManager.doFileUpload(mf, pathname);
					if (saveFilename == null) {
						continue;
					}

					String originalFilename = mf.getOriginalFilename();
 
					dto.setOriginal_filename(originalFilename);
					dto.setSave_filename(saveFilename);
					
					dao.insertData("approval.insertFile", dto);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}			
		
	}


	@Override
	public List<Approval> listMember(Map<String, Object> map) {
		List<Approval> list = null;
		
		try {
			list = dao.selectList("approval.listMember", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public List<Approval> listApproval(Map<String, Object> map) {
		List<Approval> list = null;
		
		try {
			list = dao.selectList("approval.listApproval", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	@Override
	public int dataCount(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = dao.selectOne("approval.dataCount", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}


	@Override
	public Approval readApproval(long doc_no) {
		Approval dto = null;
		
		try {
			dto = dao.selectOne("approval.readApproval", doc_no);
		} catch (Exception e) {
			e.printStackTrace();
		}
				
		return dto;
	}


	@Override
	public void updateApproval(Approval dto, String pathname) throws Exception {
		// TODO Auto-generated method stub
		
	}


	@Override
	public List<Approval> listFile(long doc_no) {
		List<Approval> listFile = null;
		
		try {
			listFile = dao.selectList("approval.listFile", doc_no);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return listFile;
	}




}
