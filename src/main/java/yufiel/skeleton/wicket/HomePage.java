package yufiel.skeleton.wicket;

import com.giffing.wicket.spring.boot.context.scan.WicketHomePage;
import org.apache.wicket.markup.html.WebPage;
import org.apache.wicket.markup.html.basic.Label;
import org.apache.wicket.model.Model;
import org.wicketstuff.annotation.mount.MountPath;

/**
 * TODO Add Java doc here
 *
 * @author Steffen Maas (smaas@voipfuture.com)
 */
@WicketHomePage
@MountPath("home")
public class HomePage extends WebPage {

    @Override
    protected void onInitialize()
    {
        super.onInitialize();

        add(new Label("test", Model.of(getString("example.message"))));
    }
}
