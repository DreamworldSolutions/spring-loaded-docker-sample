package com.dw.springloadeddockersample;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestController {
  private static final Logger logger = LoggerFactory.getLogger(TestController.class);

  @RequestMapping(value = "/test", method = RequestMethod.GET)
  @ResponseStatus(value = HttpStatus.OK)
  @PreAuthorize("hasAnyRole('ROLE_USER')")
  public String test() {
    logger.debug("test() :: execute");
    return "Hello\n";
  }
}
