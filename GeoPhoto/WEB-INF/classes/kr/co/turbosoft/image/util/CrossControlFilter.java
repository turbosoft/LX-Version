package kr.co.turbosoft.image.util;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.filter.OncePerRequestFilter;

public class CrossControlFilter extends OncePerRequestFilter implements Filter {
	protected void doFilterInternal(HttpServletRequest request,
			HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException
	{
		response.addHeader("Access-Control-Allow-Origin", "*");
		
		// TODO Auto-generated method stub
		if (request.getHeader("Access-Control-Request-Method") != null && "OPTIONS".equals(request.getMethod())) {
			// CORS "pre-flight	 request
			response.addHeader("Access-Control-Allow-Methods", "GET, POST, PATCH, DELETE");
			response.addHeader("Access-Control-Allow-Headers", "x-requested-with, x-request-location");
			response.addHeader("Access-Control-Max-Age", "3600");
		}
		
		filterChain.doFilter(request, response);
	}
}