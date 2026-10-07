use scraper::{Html, Selector};
use sha2::{Digest, Sha256};
use std::collections::HashSet;
use std::env;
use std::fs;
use std::path::Path;
use walkdir::WalkDir;

/// Extracts story content and the main title from standard WordPress HTML structures.
fn extract_story_data(html_content: &str) -> Option<(String, String)> {
    let document = Html::parse_document(html_content);

    // Standard WordPress main content containers in order of priority
    let content_selectors = [".entry-content", ".post-content", "article", "#content"];

    let mut selected_element = None;
    for selector_str in &content_selectors {
        if let Ok(selector) = Selector::parse(selector_str) {
            if let Some(element) = document.select(&selector).next() {
                selected_element = Some(element);
                break;
            }
        }
    }

    let element = selected_element?;

    // 1. Extract Title: Look for standard WordPress title tags or fallback to h1
    let title_selectors = [
        "h1.entry-title",
        "h1.post-title",
        ".entry-header h1",
        "article h1",
        "h1",
    ];

    let mut extracted_title = None;
    for title_sel_str in &title_selectors {
        if let Ok(selector) = Selector::parse(title_sel_str) {
            if let Some(title_elem) = document.select(&selector).next() {
                let title_text: String = title_elem.text().collect::<Vec<_>>().join(" ");
                let trimmed = title_text.trim();
                if !trimmed.is_empty() {
                    extracted_title = Some(trimmed.to_string());
                    break;
                }
            }
        }
    }

    // 2. Extract Body Content
    let unwanted_tags = ["script", "style", "nav", "footer", "form", "header", "aside"];
    let mut text_parts = Vec::new();

    for node in element.descendants() {
        if let Some(text_node) = node.value().as_text() {
            let is_unwanted = node.ancestors().any(|ancestor| {
                if ancestor.id() == element.id() {
                    return false;
                }
                if let Some(elem) = ancestor.value().as_element() {
                    unwanted_tags.contains(&elem.name())
                } else {
                    false
                }
            });

            if !is_unwanted {
                let trimmed = text_node.trim();
                if !trimmed.is_empty() {
                    text_parts.push(trimmed.to_string());
                }
            }
        }
    }

    if text_parts.is_empty() {
        None
    } else {
        let story_text = text_parts.join("\n\n");
        let title = extracted_title.unwrap_or_default();
        Some((title, story_text))
    }
}

/// Sanitizes a string so it can be safely used as a filename.
fn sanitize_filename(title: &str) -> String {
    title
        .chars()
        .map(|c| match c {
            'a'..='z' | 'A'..='Z' | '0'..='9' | '-' | '_' | ' ' => Some(c),
            _ => None,
        })
        .flatten()
        .collect::<String>()
        .split_whitespace()
        .collect::<Vec<_>>()
        .join(" ")
}

/// Normalizes whitespace and casing, then generates a SHA-256 hash.
fn hash_normalized_text(text: &str) -> [u8; 32] {
    let normalized = text
        .split_whitespace()
        .collect::<Vec<_>>()
        .join(" ")
        .to_lowercase();

    let mut hasher = Sha256::new();
    hasher.update(normalized.as_bytes());
    hasher.finalize().into()
}

fn process_wordpress_dump(
    source_dir: &Path,
    output_dir: &Path,
    min_char_length: usize,
) -> Result<(), Box<dyn std::error::Error>> {
    fs::create_dir_all(output_dir)?;

    let mut seen_hashes: HashSet<[u8; 32]> = HashSet::new();
    let mut saved_count = 0;
    let mut duplicate_count = 0;

    println!("Scanning for index.html files in: {:?}", source_dir);

    for entry in WalkDir::new(source_dir).into_iter().filter_map(|e| e.ok()) {
        let path = entry.path();

        if path.is_file() && path.file_name().and_then(|s| s.to_str()) == Some("index.html") {
            if let Ok(html_content) = fs::read_to_string(path) {
                if let Some((extracted_title, story_text)) = extract_story_data(&html_content) {
                    if story_text.len() < min_char_length {
                        continue;
                    }

                    let text_hash = hash_normalized_text(&story_text);

                    if seen_hashes.contains(&text_hash) {
                        duplicate_count += 1;
                        continue;
                    }

                    seen_hashes.insert(text_hash);

                    // Determine base filename: use extracted title or fallback to parent directory name
                    let raw_name = if !extracted_title.is_empty() {
                        extracted_title
                    } else {
                        path.parent()
                            .and_then(|p| p.file_name())
                            .and_then(|s| s.to_str())
                            .unwrap_or("story")
                            .to_string()
                    };

                    let safe_filename = sanitize_filename(&raw_name);
                    let output_filename = format!("{}.txt", safe_filename);
                    let output_file_path = output_dir.join(output_filename);

                    fs::write(output_file_path, story_text)?;
                    saved_count += 1;
                }
            }
        }
    }

    println!("\n--- Summary ---");
    println!("Unique stories saved: {}", saved_count);
    println!("Duplicates discarded: {}", duplicate_count);

    Ok(())
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = env::args().collect();
    let source = args
        .get(1)
        .map(|s| s.as_str())
        .unwrap_or("/media/stories/dave_potter/raw");
    let output = args
        .get(2)
        .map(|s| s.as_str())
        .unwrap_or("/media/stories/dave_potter/stories");
    let min_character_length = 150;

    process_wordpress_dump(Path::new(source), Path::new(output), min_character_length)?;

    Ok(())
}
