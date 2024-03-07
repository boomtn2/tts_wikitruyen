// String jsLeakChiMuc() {
//   return '''
// var liElements = document.querySelectorAll('div.volume-list ul.pagination li');

// var paginationData = [];


// liElements.forEach(function(liElement) {
//     var anchorElement = liElement.querySelector('a');

//     if (anchorElement) {
  
         
//         var textContent = anchorElement.textContent.trim();
        
//         var liClasses = liElement.className; 

//         var liItem = {
 
//             "textContent": textContent,
            
//             "liClasses": liClasses 
//         };

//         paginationData.push(liItem);
//     }
// });


// var jsonData = JSON.stringify(paginationData);


//  jsonData;
//  ''';
// }

// String jsChapter = '''
// var liElements = document.querySelectorAll('li.chapter-name');

 
// var liData = [];

 
// liElements.forEach(function(liElement) {
//     var anchorElement = liElement.querySelector('a');

 
//     if (anchorElement) {
//         var href = anchorElement.getAttribute('href');
//         var textContent = anchorElement.textContent.trim();

 
//         var liItem = {
//             "href": 'https://wikisach.net/'+href,
//             "textContent": textContent
//         };

 
//         liData.push(liItem);
//     }
// });

 
// var jsonData = JSON.stringify(liData);
// jsonData;
// ''';

// String actionNext = '''
// var father = document.querySelector('ul.pagination');
// var aElements = father.querySelectorAll('a[data-action="loadBookIndex"]');
//         aElements.forEach(function(aElement) {
//           if (aElement.textContent.trim() === '?') {
//             aElement.click();
//           }
//         });
// ''';

// String textMoTa = '''
// document.querySelector('div.book-desc-detail').textContent;
// ''';

// String theLoaiJS = '''
// var liElement = document.querySelector('.book-desc p');

 
// var liData = [];

 

//     var anchorElement = liElement.querySelectorAll('a');
// anchorElement.forEach(function(liElement) {
 
//     if (anchorElement) {
//         var href = liElement.getAttribute('href');
//         var textContent = liElement.textContent.trim();

      
//         var liItem = {
//             "href": 'https://wikisach.net/'+href,
//             "textContent": textContent
//         };

    
//         liData.push(liItem);
//     }
// });

 
// var jsonData = JSON.stringify(liData);
// jsonData;
// ''';

// String tatHML = '''
// var allElements = document.querySelectorAll('*');
// allElements.forEach(function(element) {
//     element.style.display = 'none';
// });
// ''';
