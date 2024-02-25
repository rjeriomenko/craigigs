const { app, BrowserWindow } = require('electron');
const puppeteer = require('puppeteer');

const createWindow = (width = 1000, height = 750) => {
  const win = new BrowserWindow({
    width,
    height,
    webPreferences: {
      devTools: true,
    },
  });

  return win;
}

// Close the app when all windows are closed on Windows and Linux
app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') app.quit();
  })
  
  // Start the app and run it
app.whenReady().then(async () => {
  const mainWindow = createWindow();
  mainWindow.loadFile('index.html');

  const browser = await puppeteer.launch({ headless:false });
  const page = await browser.newPage();

/////////////////////////////////// SAMPLE TEST CODE
  // Navigate the page to a URL
  await page.goto('https://developer.chrome.com/');

  // Set screen size
  await page.setViewport({width: 1000, height: 1024});

  // Type into search box
  await page.type('.devsite-search-field', 'automate beyond recorder');

  // Wait and click on first result
  const searchResultSelector = '.devsite-result-item-link';
  await page.waitForSelector(searchResultSelector);
  await page.click(searchResultSelector);

  // Locate the full title with a unique string
  const textSelector = await page.waitForSelector(
    'text/Customize and automate'
  );
  const fullTitle = await textSelector?.evaluate(el => el.textContent);

  // Print the full title
  console.log('The title of this blog post is "%s".', fullTitle);
/////////////////////////////////// SAMPLE TEST CODE

  // Create a window if there are none on Mac
  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  })
})