package org.example;

import static org.junit.Assert.assertTrue;

import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;

/**
 * Unit test for simple App.
 */
public class AppTest 
{
    /**
     * Rigorous Test :-)
     */
    @Test
    public void shouldAnswerWithTrue() throws InterruptedException {
        //initilize
        System.setProperty("webdriver.chrome.driver", "I:\\Semester5\\e17-3yp-smart-apartment-security-system\\Webtest\\Chrome drive\\chromedriver.exe");
        WebDriver driver = new ChromeDriver();
        driver.get("http://localhost:8081/");

        //login tests1

        //login correctly
        driver.findElement(By.xpath("//*[@id=\"email\"]")).sendKeys("kanishkamdilhan@gmail.com");
        driver.findElement(By.xpath("//*[@id=\"password\"]")).sendKeys("Abcd123");
        driver.findElement(By.xpath("/html/body/div/div/div/div/form/button")).click();

        //move in header menue
        driver.findElement(By.xpath("//*[@id=\"navbarSupportedContent\"]/ul/li[1]/a")).click();
        driver.findElement(By.xpath("//*[@id=\"navbarSupportedContent\"]/ul/li[2]/a")).click();
        driver.findElement(By.xpath("//*[@id=\"navbarSupportedContent\"]/ul/li[3]/a")).click();
        driver.findElement(By.xpath("//*[@id=\"navbarSupportedContent\"]/ul/li[4]/a")).click();

        //apartment test
        driver.findElement(By.xpath("//*[@id=\"navbarSupportedContent\"]/ul/li[2]/a")).click();
        //add apartment
        driver.findElement(By.xpath("//*[@id=\"site-main\"]/div/a")).click();
        driver.findElement(By.xpath("//*[@id=\"name\"]")).sendKeys("Hill Villa");
        driver.findElement(By.xpath("//*[@id=\"houseno\"]")).sendKeys("HN001 ,HN002 ,HN008");
        driver.findElement(By.xpath("//*[@id=\"owner\"]")).sendKeys("Mr Weerasigha");
        driver.findElement(By.xpath("//*[@id=\"mobileno\"]")).sendKeys("0778653452");
        driver.findElement(By.xpath("//*[@id=\"location\"]")).sendKeys("Nuwaraeli");
        driver.findElement(By.xpath("/html/body/div/div/div/div/form/button")).click();
        //add apartment
        driver.findElement(By.xpath("//*[@id=\"site-main\"]/div/a")).click();
        driver.findElement(By.xpath("//*[@id=\"name\"]")).sendKeys("Beach Villa");
        driver.findElement(By.xpath("//*[@id=\"houseno\"]")).sendKeys("HN009 ,HN008 ,HN007");
        driver.findElement(By.xpath("/html/body/div/div/div/div/form/button")).click();
        Thread.sleep(500);
        driver.findElement(By.xpath("//*[@id=\"owner\"]")).sendKeys("Mr Jayawardana");
        driver.findElement(By.xpath("//*[@id=\"mobileno\"]")).sendKeys("0777685360");
        driver.findElement(By.xpath("//*[@id=\"location\"]")).sendKeys("Mathara");
        driver.findElement(By.xpath("/html/body/div/div/div/div/form/button")).click();
        //add apartment
        driver.findElement(By.xpath("//*[@id=\"site-main\"]/div/a")).click();
        driver.findElement(By.xpath("//*[@id=\"name\"]")).sendKeys("Fantacy land");
        driver.findElement(By.xpath("//*[@id=\"houseno\"]")).sendKeys("HN011, HN022");
        driver.findElement(By.xpath("//*[@id=\"owner\"]")).sendKeys("Mr Kumara");
        driver.findElement(By.xpath("//*[@id=\"mobileno\"]")).sendKeys("0777682222");
        driver.findElement(By.xpath("/html/body/div/div/div/div/form/button")).click();
        Thread.sleep(500);
        driver.findElement(By.xpath("//*[@id=\"location\"]")).sendKeys("Colombo");
        driver.findElement(By.xpath("/html/body/div/div/div/div/form/button")).click();
        //delete apartement
        //driver.findElement(By.xpath("//*[@id=\"site-main\"]/div/form/table/tbody/tr[2]/td[7]/a[2]")).click();
        //edit apartment
        driver.findElement(By.xpath("//*[@id=\"site-main\"]/div/form/table/tbody/tr[4]/td[7]/a[1]")).click();
        driver.findElement(By.xpath("//*[@id=\"location\"]")).clear();
        driver.findElement(By.xpath("//*[@id=\"location\"]")).sendKeys("Jaffna");
        driver.findElement(By.xpath("/html/body/div/div/div/div/form/button")).click();

        //delete apartement
        driver.findElement(By.xpath("//*[@id=\"site-main\"]/div/form/table/tbody/tr[3]/td[7]/a[2]")).click();

        //securityofficer test
        driver.findElement(By.xpath("//*[@id=\"navbarSupportedContent\"]/ul/li[3]/a")).click();
        //add officer
        driver.findElement(By.xpath("//*[@id=\"site-main\"]/div/a")).click();
        driver.findElement(By.xpath("//*[@id=\"name\"]")).sendKeys("Kumara Pathirana");
        driver.findElement(By.xpath("//*[@id=\"ApartmentID\"]")).sendKeys("AS001");
        driver.findElement(By.xpath("//*[@id=\"MobileNo\"]")).sendKeys("0771234567");
        driver.findElement(By.xpath("//*[@id=\"email\"]")).sendKeys("kumara@gmail.com");
        driver.findElement(By.xpath("//*[@id=\"password\"]")).sendKeys("1111");
        driver.findElement(By.xpath("/html/body/div/div/div/div/form/button")).click();

        //add officer
        driver.findElement(By.xpath("//*[@id=\"site-main\"]/div/a")).click();
        driver.findElement(By.xpath("//*[@id=\"name\"]")).sendKeys("Bandara gamage");
        driver.findElement(By.xpath("//*[@id=\"ApartmentID\"]")).sendKeys("AS007");
        driver.findElement(By.xpath("//*[@id=\"MobileNo\"]")).sendKeys("0771231111");
        driver.findElement(By.xpath("/html/body/div/div/div/div/form/button")).click();
        Thread.sleep(500);
        driver.findElement(By.xpath("//*[@id=\"email\"]")).sendKeys("Banda@gmail.com");
        driver.findElement(By.xpath("//*[@id=\"password\"]")).sendKeys("2222");
        driver.findElement(By.xpath("/html/body/div/div/div/div/form/button")).click();
        //edit
        driver.findElement(By.xpath("//*[@id=\"site-main\"]/div/form/table/tbody/tr[2]/td[6]/a[1]")).click();
        driver.findElement(By.xpath("//*[@id=\"name\"]")).clear();
        driver.findElement(By.xpath("//*[@id=\"name\"]")).sendKeys("New name");
        driver.findElement(By.xpath("/html/body/div/div/div/div/form/button")).click();
        //delete
        driver.findElement(By.xpath("//*[@id=\"site-main\"]/div/form/table/tbody/tr[3]/td[6]/a[2]")).click();


        //sensor test
        driver.findElement(By.xpath("//*[@id=\"navbarSupportedContent\"]/ul/li[4]/a")).click();
        //add sensor
        driver.findElement(By.xpath("//*[@id=\"site-main\"]/div/a")).click();
        driver.findElement(By.xpath("//*[@id=\"uniqueid\"]")).sendKeys("SS0001");
        driver.findElement(By.xpath("//*[@id=\"type\"]")).sendKeys("Window");
        driver.findElement(By.xpath("//*[@id=\"mode\"]")).sendKeys("True");
        driver.findElement(By.xpath("//*[@id=\"status\"]")).sendKeys("Deactive");
        driver.findElement(By.xpath("//*[@id=\"houseid\"]")).sendKeys("HN001");
        driver.findElement(By.xpath("//*[@id=\"apartmentid\"]")).sendKeys("AR009");
        driver.findElement(By.xpath("/html/body/div/div/div/div/form/button")).click();
        //add sensor
        driver.findElement(By.xpath("//*[@id=\"site-main\"]/div/a")).click();
        driver.findElement(By.xpath("//*[@id=\"uniqueid\"]")).sendKeys("SS0002");
        driver.findElement(By.xpath("//*[@id=\"type\"]")).sendKeys("Door");
        driver.findElement(By.xpath("//*[@id=\"mode\"]")).sendKeys("False");
        driver.findElement(By.xpath("/html/body/div/div/div/div/form/button")).click();
        Thread.sleep(500);
        driver.findElement(By.xpath("//*[@id=\"status\"]")).sendKeys("Active");
        driver.findElement(By.xpath("//*[@id=\"houseid\"]")).sendKeys("HN001");
        driver.findElement(By.xpath("//*[@id=\"apartmentid\"]")).sendKeys("AR009");
        driver.findElement(By.xpath("/html/body/div/div/div/div/form/button")).click();
        //edit
        driver.findElement(By.xpath("//*[@id=\"site-main\"]/div/form/table/tbody/tr[4]/td[7]/a[1]")).click();
        driver.findElement(By.xpath("//*[@id=\"houseid\"]")).clear();
        driver.findElement(By.xpath("//*[@id=\"houseid\"]")).sendKeys("HN202");
        driver.findElement(By.xpath("/html/body/div/div/div/div/form/button")).click();
        //delete
        driver.findElement(By.xpath("//*[@id=\"site-main\"]/div/form/table/tbody/tr[3]/td[7]/a[2]")).click();

        //logout
        driver.findElement(By.xpath("//*[@id=\"navbarSupportedContent\"]/div/form")).click();
    }
}
