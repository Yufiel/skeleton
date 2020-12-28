package yufiel.skeleton;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ServletComponentScan
@ComponentScan("yufiel")
public class WicketApplication
{
    public static void main(String[] args)
    {
        new SpringApplicationBuilder()
            .sources(WicketApplication.class)
            .run(args);
    }
}